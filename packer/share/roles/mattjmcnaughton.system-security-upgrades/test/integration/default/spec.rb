describe package("unattended-upgrades") do
  it { should be_installed }
end

describe command('apt-config dump APT::Periodic::Unattended-Upgrade') do
  its('stdout') { should match (/1/) }
end

describe command('apt-config dump Unattended-Upgrade::Allowed-Origins') do
  its('stdout') { should match (/security/) }
end
