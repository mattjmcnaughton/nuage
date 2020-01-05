# k8s

Generate virtualbox images/AMIs for k8s. Can use the same image for master and
worker.

This packer role is unique in that we have an `integration` directory in which
we use our constructed vagrant box to bring up a k8s master and node and then
test they can communicate with each other.
