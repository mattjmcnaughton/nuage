# terraform-bootstrap

We SHOULD manage as view resources in this bootstrap layer as possible.

This terraform repo is responsible for provisioning foundational infrastructure.
For example, the proper S3 bucket that we can use as a terraform backend.

We store the state locally, but only commit gpg encrypted versions to source
control.

## Assumptions

This terraform configuration makes the following assumptions:

- Already have an AWS account.
