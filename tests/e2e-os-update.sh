#!/bin/bash
# Both pipeline examples, run for real: their own steps, lifted out of the
# YAML and executed in a runner container against a target container with
# sshd and a sudo account.
#   - the upgrade runs on the target, and the job says whether a reboot is
#     needed;
#   - a host that hands over no host key stops the job before any connection;
#   - a host whose key changed between the scan and the connection - the
#     target's name moved to an impostor with other keys but the same
#     account - is refused, which is what StrictHostKeyChecking=yes is for.
# tests/plant-violations.py breaks each promise in a copy of the examples and
# requires this to notice.
#
#   ./tests/e2e-os-update.sh        (needs Docker)
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1
RUN="osupdate-e2e-$$"
PASSED=0; FAILED=0
check() { if [ "$1" = yes ]; then echo "  PASS: $2"; PASSED=$((PASSED+1)); else echo "  FAIL: $3"; FAILED=$((FAILED+1)); fi; }
has() { if grep -qE "$1" <<<"$2"; then echo yes; else echo no; fi; }
lacks() { if grep -qE "$1" <<<"$2"; then echo no; else echo yes; fi; }
WORK="$(mktemp -d)"
cleanup() { docker rm -f "$RUN-target" "$RUN-impostor" "$RUN-mute" "$RUN-runner" >/dev/null 2>&1; docker network rm "$RUN" >/dev/null 2>&1; rm -rf "$WORK"; }
trap cleanup EXIT

docker build -q -t local/os-update-target - >/dev/null <<'DOCKERFILE'
FROM ubuntu:24.04
RUN apt-get update -qq && apt-get install -y -qq openssh-server sudo >/dev/null \
 && useradd -m -s /bin/bash deploy && echo 'deploy ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/deploy \
 && mkdir -p /run/sshd /home/deploy/.ssh && chown -R deploy /home/deploy/.ssh
# Host keys are made when the container starts, so no two containers share one.
CMD ["sh", "-c", "rm -f /etc/ssh/ssh_host_* && ssh-keygen -A >/dev/null && exec /usr/sbin/sshd -D -e"]
DOCKERFILE
docker build -q -t local/os-update-runner - >/dev/null <<'DOCKERFILE'
FROM ubuntu:24.04
RUN apt-get update -qq && apt-get install -y -qq openssh-client python3-yaml >/dev/null
DOCKERFILE

ssh-keygen -q -t ed25519 -N '' -f "$WORK/key"
docker network create "$RUN" >/dev/null
sshd_host() {  # sshd_host <container> <alias-or-empty>: an sshd that accepts the job's key
  docker run -d --name "$1" ${2:+--network "$RUN" --network-alias "$2"} local/os-update-target >/dev/null
  docker cp "$WORK/key.pub" "$1:/home/deploy/.ssh/authorized_keys"
  docker exec "$1" sh -c 'chown deploy /home/deploy/.ssh/authorized_keys && chmod 600 /home/deploy/.ssh/authorized_keys'
}
sshd_host "$RUN-target" target
sshd_host "$RUN-impostor" ""
docker run -d --name "$RUN-mute" --network "$RUN" --network-alias mute ubuntu:24.04 sleep 900 >/dev/null
docker run -d --name "$RUN-runner" --network "$RUN" local/os-update-runner sleep 900 >/dev/null
for _ in $(seq 1 20); do docker exec "$RUN-target" test -s /etc/ssh/ssh_host_ed25519_key.pub && break; sleep 1; done

# steps <example>: the example's shell, split where a runner would split it:
# everything that prepares the connection, then the step that makes it.
steps() {
  docker cp "$1" "$RUN-runner:/example.yml"
  docker exec -i "$RUN-runner" python3 - <<'PY'
import yaml
d = yaml.safe_load(open("/example.yml"))
if "jobs" in d:
    runs = [s["run"] for job in d["jobs"].values() for s in job.get("steps", []) if "run" in s]
    prep, connect = runs[:-1], runs[-1:]
else:
    job = next(v for v in d.values() if isinstance(v, dict) and "script" in v)
    prep, connect = job.get("before_script", []), job["script"]
print("\n".join(prep)); print("#---CONNECT---"); print("\n".join(connect))
PY
}
# run_example <example> <host> [between]: prepare, run <between> if given, connect.
run_example() {
  steps "$1" > "$WORK/all.sh"
  sed '/^#---CONNECT---$/,$d' "$WORK/all.sh" > "$WORK/prep.sh"
  sed '1,/^#---CONNECT---$/d' "$WORK/all.sh" > "$WORK/connect.sh"
  docker cp "$WORK/prep.sh" "$RUN-runner:/prep.sh"; docker cp "$WORK/connect.sh" "$RUN-runner:/connect.sh"
  docker exec "$RUN-runner" rm -rf /root/.ssh
  local env=(-e SSH_USER=deploy -e EC2_HOST="$2" -e SSH_PRIVATE_KEY="$(cat "$WORK/key")" -e REASON=e2e)
  docker exec "${env[@]}" "$RUN-runner" bash -e /prep.sh 2>&1 || return $?
  [ -z "${3:-}" ] || "$3"
  docker exec "${env[@]}" "$RUN-runner" bash -e /connect.sh 2>&1
}
# The target's name moves to the impostor between the key scan and the login.
swap_to_impostor() {
  docker network disconnect "$RUN" "$RUN-target" >/dev/null
  docker network connect --alias target "$RUN" "$RUN-impostor" >/dev/null
}
swap_back() {
  docker network disconnect "$RUN" "$RUN-impostor" >/dev/null 2>&1
  docker network connect --alias target "$RUN" "$RUN-target" >/dev/null 2>&1
}

for ex in .github/workflows/00-os-update.yml.example gitlab-ci.yml.example; do
  echo "=== $ex"
  out="$(run_example "$ex" target)"; rc=$?
  check "$([ "$rc" -eq 0 ] && echo yes || echo no)" "the job completes against a reachable host" "the job failed (exit $rc): $(tail -3 <<<"$out" | tr '\n' ' ')"
  check "$(has 'upgraded, .* newly installed' "$out")" "apt-get upgrade ran on the target" "no upgrade summary in the job's output"
  check "$(has 'REBOOT REQUIRED|no reboot needed' "$out")" "the job says whether a reboot is needed" "the job did not say whether a reboot is needed"

  out="$(run_example "$ex" mute)"; rc=$?
  check "$([ "$rc" -ne 0 ] && echo yes || echo no)" "a host with no host key stops the job" "the job went on against a host it had no key for"
  check "$(lacks 'upgraded' "$out")" "and nothing was run on it" "an upgrade ran on a host whose key was never obtained"

  out="$(run_example "$ex" target swap_to_impostor)"; rc=$?
  swap_back
  check "$([ "$rc" -ne 0 ] && echo yes || echo no)" "a host whose key changed after the scan is refused" "the job logged in to a host whose key had changed"
  check "$(lacks 'upgraded' "$out")" "and nothing was run on the impostor" "an upgrade ran on the impostor"
done

echo
echo "passed: $PASSED   failed: $FAILED"
[ "$FAILED" -eq 0 ]
