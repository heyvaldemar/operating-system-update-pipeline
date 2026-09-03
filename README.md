# Operating System Update Pipeline Using GitHub Actions or GitLab CI/CD

This guide outlines the process to set up and execute Operating System updates using either GitHub Actions or GitLab CI/CD.

## GitHub Actions

`.github` is useful if you are planning to run a pipeline on GitHub and implement the GitOps approach.

Remove the `.example` part from the name of the files in `.github/workflow` for the GitHub Actions pipeline to work.

You can delete `.github` if you are not planning to use the GitHub pipeline.

## Run the OS update workflow using GitHub Actions

1. Ensure you have the required secrets (`SSH_USER`, `EC2_HOST`, and `SSH_PRIVATE_KEY`) set up in your repository's Secrets settings.
2. Ensure the EC2 instance's security group allows incoming SSH connections from the GitHub Actions runner IP addresses.
3. Make sure the SSH user has the necessary permissions on the EC2 instance, including `sudo` permissions if required.

### Steps

1. **Navigate to the GitHub Repository**: Go to your repository where the workflow is set up.

2. **Go to the 'Actions' Tab**: Located at the top of your repository.

3. **Select the 'Application Update' Workflow**: You should see this on the left sidebar. Click on it.

4. **Run Workflow**: Towards the right side, you'll see a "Run workflow" dropdown. Click on it.

5. **Provide Input (Optional)**:
    - You can provide a reason for the run in the "Reason for run" input box. This is optional.

6. **Click 'Run workflow' Button**: After clicking, the workflow will start, and you can observe its progress.

7. **Check the Results**: Once the workflow completes, you can click on the specific job to view the logs and see if the OS update was successful on your EC2 instance.

## GitLab CI/CD

`.gitlab-ci.yml` is useful if you are planning to run a pipeline on GitLab and implement the GitOps approach.

Remove the `.example` part from the name of the files in the root or designated CI/CD directory to make the GitLab CI/CD pipeline operational.

You can delete `.gitlab-ci.yml` if you are not planning to use the GitLab pipeline.

## Run the OS update workflow using GitLab CI/CD

1. Ensure you have the required CI/CD variables (`SSH_USER`, `EC2_HOST`, and `SSH_PRIVATE_KEY`) set up in your GitLab project's settings.
2. Ensure the EC2 instance's security group allows incoming SSH connections from the GitLab runner IP addresses.
3. Make sure the SSH user has `sudo` permissions on the EC2 instance to run update commands.

### Steps

1. **Navigate to the GitLab Project**: Go to your project where the `.gitlab-ci.yml` file is set up.
  
2. **Go to the 'CI/CD' Section**: Located in the left sidebar of your project.
  
3. **Select the 'Pipelines' Tab**: Here, you'll see a list of pipelines that have been run or are scheduled to run.
  
4. **Run Pipeline**: At the top-right corner, you'll find the "Run Pipeline" button. Click on it.
  
5. **Choose the 'main' Branch**: As the `os_update` job is set to run only on the `main` branch.
  
6. **Click 'Run Pipeline' Button**: Once you've selected the branch, click the "Run Pipeline" button. This will initiate the OS update job, and you can monitor its progress.
  
7. **Check the Results**: After completion, you can click on the specific job within the pipeline to view the logs and verify if the OS update was successful on your EC2 instance.

## Author

hey everyone,

💾 I’ve been in the IT game for over 20 years, cutting my teeth with some big names like [IBM](https://www.linkedin.com/in/heyvaldemar/), [Thales](https://www.linkedin.com/in/heyvaldemar/), and [Amazon](https://www.linkedin.com/in/heyvaldemar/). These days, I wear the hat of a DevOps Consultant and Team Lead, but what really gets me going is Docker and container technology - I’m kind of obsessed!

💛 I have my own IT [blog](https://www.heyvaldemar.com/), where I’ve built a [community](https://discord.gg/AJQGCCBcqf) of DevOps enthusiasts who share my love for all things Docker, containers, and IT technologies in general. And to make sure everyone can jump on this awesome DevOps train, I write super detailed guides (seriously, they’re foolproof!) that help even newbies deploy and manage complex IT solutions.

🚀 My dream is to empower every single person in the DevOps community to squeeze every last drop of potential out of Docker and container tech.

🐳 As a [Docker Captain](https://www.docker.com/captains/vladimir-mikhalev/), I’m stoked to share my knowledge, experiences, and a good dose of passion for the tech. My aim is to encourage learning, innovation, and growth, and to inspire the next generation of IT whizz-kids to push Docker and container tech to its limits.

Let’s do this together!

## My 2D Portfolio

🕹️ Click into [sre.gg](https://www.sre.gg/) — my virtual space is a 2D pixel-art portfolio inviting you to interact with elements that encapsulate the milestones of my DevOps career.

## My Courses

🎓 Dive into my [comprehensive IT courses](https://www.heyvaldemar.com/courses/) designed for enthusiasts and professionals alike. Whether you're looking to master Docker, conquer Kubernetes, or advance your DevOps skills, my courses provide a structured pathway to enhancing your technical prowess.

🔑 [Each course](https://www.udemy.com/user/heyvaldemar/) is built from the ground up with real-world scenarios in mind, ensuring that you gain practical knowledge and hands-on experience. From beginners to seasoned professionals, there's something here for everyone to elevate their IT skills.

## My Services

💼 Take a look at my [service catalog](https://www.heyvaldemar.com/services/) and find out how we can make your technological life better. Whether it's increasing the efficiency of your IT infrastructure, advancing your career, or expanding your technological horizons — I'm here to help you achieve your goals. From DevOps transformations to building gaming computers — let's make your technology unparalleled!

## Patreon Exclusives

🏆 Join my [Patreon](https://www.patreon.com/heyvaldemar) and dive deep into the world of Docker and DevOps with exclusive content tailored for IT enthusiasts and professionals. As your experienced guide, I offer a range of membership tiers designed to suit everyone from newbies to IT experts.

## My Recommendations

📕 Check out my collection of [essential DevOps books](https://kit.co/heyvaldemar/essential-devops-books)\
🖥️ Check out my [studio streaming and recording kit](https://kit.co/heyvaldemar/my-studio-streaming-and-recording-kit)\
📡 Check out my [streaming starter kit](https://kit.co/heyvaldemar/streaming-starter-kit)

## Follow Me

🎬 [YouTube](https://www.youtube.com/channel/UCf85kQ0u1sYTTTyKVpxrlyQ?sub_confirmation=1)\
🐦 [X / Twitter](https://twitter.com/heyvaldemar)\
🎨 [Instagram](https://www.instagram.com/heyvaldemar/)\
🐘 [Mastodon](https://mastodon.social/@heyvaldemar)\
🧵 [Threads](https://www.threads.net/@heyvaldemar)\
🎸 [Facebook](https://www.facebook.com/heyvaldemarFB/)\
🧊 [Bluesky](https://bsky.app/profile/heyvaldemar.bsky.social)\
🎥 [TikTok](https://www.tiktok.com/@heyvaldemar)\
💻 [LinkedIn](https://www.linkedin.com/in/heyvaldemar/)\
📣 [daily.dev Squad](https://app.daily.dev/squads/devopscompass)\
🧩 [LeetCode](https://leetcode.com/u/heyvaldemar/)\
🐈 [GitHub](https://github.com/heyvaldemar)

## Community of IT Experts

👾 [Discord](https://discord.gg/AJQGCCBcqf)

## Refill My Coffee Supplies

💖 [PayPal](https://www.paypal.com/paypalme/heyvaldemarCOM)\
🏆 [Patreon](https://www.patreon.com/heyvaldemar)\
💎 [GitHub](https://github.com/sponsors/heyvaldemar)\
🥤 [BuyMeaCoffee](https://www.buymeacoffee.com/heyvaldemar)\
🍪 [Ko-fi](https://ko-fi.com/heyvaldemar)

🌟 **Bitcoin (BTC):** bc1q2fq0k2lvdythdrj4ep20metjwnjuf7wccpckxc\
🔹 **Ethereum (ETH):** 0x76C936F9366Fad39769CA5285b0Af1d975adacB8\
🪙 **Binance Coin (BNB):** bnb1xnn6gg63lr2dgufngfr0lkq39kz8qltjt2v2g6\
💠 **Litecoin (LTC):** LMGrhx8Jsx73h1pWY9FE8GB46nBytjvz8g

<div align="center">

### Show some 💜 by starring some of the [repositories](https://github.com/heyValdemar?tab=repositories)!

![octocat](https://user-images.githubusercontent.com/10498744/210113490-e2fad07f-4488-4da8-a656-b9abbdd8cb26.gif)

</div>

![footer](https://user-images.githubusercontent.com/10498744/210157572-1fca0242-8af2-46a6-bfa3-666ffd40ebde.svg)
