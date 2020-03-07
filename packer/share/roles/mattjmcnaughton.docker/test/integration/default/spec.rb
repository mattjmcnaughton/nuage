packages = %w(
  docker-ce
)

packages.each do |package|
  describe package(package) do
    it { should be_installed }
  end
end

services = %w(
  docker
)

running_services = %w(
  docker
)

services.each do |service|
  describe service(service) do
    it { should be_installed }
    it { should be_enabled }

    if running_services.include? service
      it { should be_running }
    end
  end
end
