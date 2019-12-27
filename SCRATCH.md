# Scratch

## Deploying blog host

- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
- Can create an ansible role which will write the script to download the proper
  ssl certs and pack that script into the AMI. However, we will not actually
  execute it.
- Then, can use `runcmd` to run the script.
