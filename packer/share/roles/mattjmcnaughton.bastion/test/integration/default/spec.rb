# We don't test for every package we removed because there isn't a ton of
# benefit.
describe package("ftp") do
  it { should_not be_installed }
end

# I'm not positive why port 68 is open... maybe making a dhcp request? Not super
# worried about it.
port_whitelist = [22, 53, 68]
describe port.where { port > 1 && port < 65535 && !port_whitelist.include?(port) } do
  it { should_not be_listening }
end
