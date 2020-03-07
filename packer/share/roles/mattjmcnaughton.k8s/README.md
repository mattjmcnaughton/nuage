# mattjmcnaughton.k8s

Role for preparing a base host on which we can run k8s.

NOTE, we do not actually run `kubeadm`. We will do that when bootstrapping the
hosts (i.e. as part of the cloud_init script)... We create the scripts we will
run.

Also, this role is not responsible for installing docker. We leave that to a
separate role.

## Helpful links

- https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network
- https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#automating-kubeadm
- https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-join/#file-or-https-based-discovery

## Thoughts

- I _think_ file based discovery is the easiest way to have workers join.
- We will need some "after launch" tasks which adds the pod network and also
  creates a non-admin user for me to use.
- Need to upload the `admin.conf` for the cluster to s3.
- Need to decide where I will manage the firewall... at the very least, need to
  open up port 6443.
