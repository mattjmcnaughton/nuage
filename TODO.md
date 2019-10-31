# TODO

Brain dump of tasks to complete on this project.

## Bugs
- [ ] Successfully launch bastion host on AWS... (ssh issue).

## Applications
- [ ] Deploy bastion host for ssh access.
- [ ] Deploy Vault
- [ ] Deploy self-hosted k8s (via kubeadm)
- [ ] Deploy sr.ht or gitlab or some git client...
- [ ] Deploy ELK stack
- [ ] Deploy NextCloud

## Improvements
- [ ] Test all terraform via terratest test all packer via terratest.
  - Where do we want to store these tests? Should each module/packer
    configuration have its own `test` directory? Or should we have one top level
    `test` directory?
- [ ] Manage mattjmcnaughton.com and mattjmcnaughton.io DNS entirely via this
  project.
