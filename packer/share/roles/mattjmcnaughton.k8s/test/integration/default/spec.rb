packages = %w(
  kubelet
  kubeadm
)

packages.each do |package|
  describe package(package) do
    it { should be_installed }
  end
end

services = %w(
  kubelet
)

running_services = %w(
)

services.each do |service|
  describe service(service) do
    it { should be_installed }
    it { should be_enabled }

    if running_services.include? service
      it { should be_running }
    else
      it { should_not be_running }
    end
  end
end
