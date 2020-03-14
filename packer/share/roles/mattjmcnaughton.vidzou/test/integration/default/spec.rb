describe docker_container('vidzou') do
  it { should exist }
  it { should be_running }
  its('id') { should_not eq '' }
  its('image') { should include 'vidzou' }
  its('ports') { should eq "0.0.0.0:8080->8080/tcp" }
end

# Test nginx running
#
# Test nginx port-forwarding to container
