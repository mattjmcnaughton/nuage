# orchestration

We will rarely use this environment. It's for `one-off` tasks (i.e. ones where
we know they need user input that can only be generated on the fly). We
intentionally don't save any state as there's no need.

## Current uses

- DNS challenges for Let's Encrypt. We need to on-the-fly update our DNS record
  with two different challenges. We could conceivably do this orchestration with
  Ansible... but manually Terraform is working fine for now.
