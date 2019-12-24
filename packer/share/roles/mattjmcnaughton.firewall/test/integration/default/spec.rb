if os.family == 'debian'
  describe package("ufw") do
    it { should be_installed }
  end

  describe port(22) do
    it { should be_listening }
  end

  # We don't really have a great way to use inspec to test that the expected
  # ports are NOT listening.

  # Our `os-hardening` role has opinions on these `sysctl` values. Essentially
  # we are ensuring the firewall changes we make doesn't mess them up.
  describe kernel_parameter('net.ipv4.conf.all.log_martians') do
    its(:value) { should eq 1 }
  end
  describe kernel_parameter('net.ipv4.conf.default.log_martians') do
    its(:value) { should eq 1 }
  end

  describe command('sudo ufw status verbose') do
    its('stdout') { should match (/Status: active/)}
    its('stdout') { should match (/22.*ALLOW/)}
    its('stdout') { should match (/Default: deny \(incoming\), allow \(outgoing\)/)}
  end
end
