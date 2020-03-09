# mattjmcnaughton.vidzou

Role for setting up [vidzou](https://github.com/mattjmcnaughton/vidzou)
on a host.

Note, execute this role includes the `mattjmcnaughton.nginx` role, which leaves
nginx in an insecure state (i.e. self-signed ssl
certs and hard coded user name and password). We intend to only use this image
for baking AMIs. Ensure all servers built from machine wait to serve requests
via nginx until they've installed the proper certs and credentials.
