# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **An end-to-end test of both examples.** Their own steps run against a
  container with sshd: the upgrade lands, a host with no key stops the job,
  and a host whose key changed after the scan is refused, which is the
  man-in-the-middle case the enforced host key was added for.
- **Planted violations for that test.** Each promise is broken on a copy,
  host-key checking turned off among them, and the test has to fail. Both run
  in the Verification workflow on every push.

## [1.0.0] - 2026-09-18

The first tagged release of a pipeline that had been edited in place since
2023. The content is the same shape it always was: an example workflow for
GitHub Actions and an example job for GitLab CI that update the operating
system on a host over SSH. What changed in 2026 is that the examples stopped
trusting whatever answered on port 22.

### Added

- **A workflow that lints the examples** on every push, so a copy-paste error
  in a file nobody runs here is caught here rather than on the host it was
  meant for.
- **This changelog**, and a version to point at.

### Changed

- **Both examples enforce the host key.** The first versions connected with
  host-key checking disabled, which is the setting that makes an SSH session
  indistinguishable from one to whoever is answering that address. The examples
  now take the host's public key as a value beside the user and the address,
  and refuse a host that does not present it.
- **The README asks for the version and the unedited output up front** when
  something goes wrong, because a report without either is a second round
  trip before the first question can be answered.

[Unreleased]: https://github.com/heyvaldemar/operating-system-update-pipeline/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/heyvaldemar/operating-system-update-pipeline/releases/tag/v1.0.0
