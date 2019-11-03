describe sshd_config do
  its('PermitEmptyPasswords') { should eq('no') }
  its('PasswordAuthentication') { should eq('no') }
  its('PermitRootLogin') { should eq('no') }
end
