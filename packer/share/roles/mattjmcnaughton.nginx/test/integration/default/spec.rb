describe package("nginx") do
  it { should be_installed }
end

ssl_root = "/etc/ssl"
nginx_common_name = "mattjmcnaughton.com"

nginx_ssl_privatekey_path = "#{ssl_root}/private/#{nginx_common_name}.key"
nginx_ssl_crt_path = "#{ssl_root}/certs/#{nginx_common_name}.crt"
nginx_dhparams_path = "#{ssl_root}/certs/dhparams.pem"

ssl_file_test_matrix = [
  {path: nginx_ssl_privatekey_path, mode: '0600', symlink: true},
  {path: nginx_ssl_crt_path, mode: '0600', symlink: true},
  # dhparams.pem isn't super sensitive, so fine with it being world readable.
  {path: nginx_dhparams_path, mode: '0644', symlink: false}
]

ssl_file_test_matrix.each do |ssl_file|
  describe file(ssl_file[:path])  do
    it { should exist }

    if ssl_file[:symlink]
      it { should be_symlink }
    else
      it { should_not be_symlink }
    end

    its('mode') { should cmp ssl_file[:mode] }
    its('owner') { should eq 'root' }
  end
end

nginx_conf_files = %w(
  /etc/nginx/nginx.conf
  /etc/nginx/snippets/ssl-certs.conf
  /etc/nginx/snippets/ssl-params.conf
)

nginx_conf_files.each do |conf_file|
  describe file(conf_file)  do
    it { should exist }

    its('mode') { should cmp '0644' }
    its('owner') { should eq 'root' }
  end
end

describe file('/etc/nginx/.htpasswd')  do
  it { should exist }

  its('mode') { should cmp '0600' }
  its('owner') { should eq 'www-data' }
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
  # Its not safe to have gzip enabled with ssl turned on.
  its('headers.Content-Encoding') { should_not eq 'gzip' }
end
