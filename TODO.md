# TODO

Brain dump of tasks to complete on this project.

## Bugs

## Applications
- [ ] Deploy Vault
- [ ] Deploy self-hosted k8s (via kubeadm)
- [ ] Deploy sr.ht or gitlab or some git client...
- [ ] Deploy ELK stack
- [ ] Deploy NextCloud

## Improvements
- [ ] Test all terraform via terratest and test all packer via terratest.

## Misc clean up
- Get rid of all uses of `ansible-lint` or update it to run within a container.
- [ ] For `mattjmcnaughton.*` ansible roles, variables should have form
  `mattjmcnaughton_role_name_var_name` (?)
- Where do we want to store these tests? Should each module/packer
  configuration have its own `test` directory? Or should we have one top level
  `test` directory?
- `mattjmcnaughton.com` should have `dev|staging|prod` DNS Zones just like
  `mattjmcnaughton.io`. Top level (i.e. world accessible) `mattjmcnaughton.com`
  domains can be CNAMES to `prod.mattjmcnaughton.com`.
