# TODO

Brain dump of tasks to complete on this project.

## Bugs

## Applications
- [ ] Deploy bastion host for ssh access.
- [ ] Deploy Vault
- [ ] Deploy self-hosted k8s (via kubeadm)
- [ ] Deploy sr.ht or gitlab or some git client...
- [ ] Deploy ELK stack
- [ ] Deploy NextCloud

## Improvements
- [ ] Test all terraform via terratest and test all packer via terratest.
- Dynamically select AMI based on latest with the proper tags.
  - Don't hard code AMI.
- [ ] Manage mattjmcnaughton.com and mattjmcnaughton.io DNS entirely via this
  project.

## Misc clean up
- [ ] Remove all mentions of `ansible-lint`
- [ ] For `mattjmcnaughton.*` ansible roles, variables should have form
  `mattjmcnaughton_role_name_var_name` (?)
- Where do we want to store these tests? Should each module/packer
  configuration have its own `test` directory? Or should we have one top level
  `test` directory?
