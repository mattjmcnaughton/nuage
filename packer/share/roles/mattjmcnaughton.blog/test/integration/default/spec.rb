ephemeral_working_dir = "/tmp/tmp-work-dir"
describe file (ephemeral_working_dir) do
  it { should_not exist }
end

blog_srv = "/var/www/blog"
blog_owner = "www-data"

describe file("#{blog_srv}/public") do
  its('type') { should eq :directory}
  its('owner') { should eq blog_owner }
  its('mode') { should cmp "00755" }
end

describe file("#{blog_srv}/public/index.html") do
  its('type') { should eq :file}
  its('owner') { should eq blog_owner }
  its('mode') { should cmp "00644" }
end

describe http('http://localhost/', ssl_verify: false) do
  its('status') { should cmp 301 }
end

# Check a variety of pages and ensure they are rendering correctly...
describe http('https://localhost/', ssl_verify: false) do
  its('status') { should cmp 200 }
  its('body') { should include "mattjmcnaughton" }
end

describe http('https://localhost/about/', ssl_verify: false) do
  its('status') { should cmp 200 }
  its('body') { should include "Matt" }
end

describe http('https://localhost/post/upgrading-k8s-cluster-to-1-13-6/', ssl_verify: false) do
  its('status') { should cmp 200 }
  its('body') { should include "k8s" }
end

describe http('https://localhost/mattjmcnaughton.pub.asc', ssl_verify: false) do
  its('status') { should cmp 200 }
  its('body') { should include "PUBLIC KEY BLOCK" }
end
