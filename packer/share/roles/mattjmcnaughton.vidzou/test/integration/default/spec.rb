describe docker.containers.where { names == 'vidzou' } do
  it { should be_running }
  its('images') { should include 'vidzou' }
end
