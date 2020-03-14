describe docker_container('vidzou') do
  it { should exist }
  it { should be_running }
  its('id') { should_not eq '' }
  its('image') { should include 'vidzou' }
  its('ports') { should eq "0.0.0.0:8080->8080/tcp" }
end

describe service('nginx') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe http('http://localhost/', ssl_verify: false) do
  its('status') { should cmp 301 }
end

describe http('https://localhost/', ssl_verify: false) do
  its('status') { should cmp 401 }
end

describe http('https://localhost/',
              auth: { user: 'matt', pass: 'insecure' },
              headers: { 'Accept-Encoding' => 'gzip,deflate'},
              ssl_verify: false) do
  its('status') { should cmp 200 }
  its('body') { should include 'vidzou' }
end
