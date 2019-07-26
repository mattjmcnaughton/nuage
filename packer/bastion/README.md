# bastion

`bastion` is the bastion host we launch in our public VPC, which allows ssh
access to our private VPC. It is through this ssh host that we will ssh into all
of our other hosts.

Note, we will encode our more detailed firewall configs via AWS security groups.
So this instance should have light network security, but we can rely on cloud
primitives for the predominant filtering.

We will _most likely_ add specific ssh keys at deploy time, although they will
go in a common location.

## Generic

- Use `ansible` or shell scripts? Most likely ansible
- Base playbooks or base images? (Install goss, generic hardening, etc...)
- Use `mattjmcnaughton` user.

Check out https://dev-sec.io/baselines/linux/

Inspec vs goss?
