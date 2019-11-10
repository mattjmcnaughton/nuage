# base-security-groups

Terraform module for security groups we wish to be present in all environments.

Because we use a separate VPC for dev, staging, and prod, we will need to define
these security groups in each environment.

None of these applications should be application specific...

## Included security groups.

- `allow-ssh-ingress-from-all`
- `allow-all-egress-to-all`

## Tests

TODO: Add automated testing via terratest.
