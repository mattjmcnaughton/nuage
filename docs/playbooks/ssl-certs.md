# ssl-certs

We get our ssl certs from Let's Encrypt.

## Overview

At a high level, we generate wildcard certs for "*.mattjmcnaughton.com" and
"*.mattjmcnaughton.io" using certbot and the DNS challenge.

These certs will last for ~90 days. Currently, refreshing the ssl certs is a
manual process.

We then store these certs in s3, and pull them onto the hosts which need them at
boot time. We will (most likely) store self-generated ssl certs on our machines
when building them via packer, and then replace them with the real certs at
boot. We will (most likely) relaunch our machines to pull the new certs...
although we may want to have either a push or pull based ansible job which will
check for new certs... tbd.

## Steps

1. [Optional] Launch a ubuntu 18.04 container with directories mounted in.
2. Ensure `certbot` apt package installed (`apt install certbot`)
3. Run the following for DOMAIN=(mattjmcnaughton.io|mattjmcnaughton.com):
```
certbot certonly \
  --manual \
  --preferred-challenges dns \
  --server https://acme-v02.api.letsencrypt.org/directory \
  --manual-public-ip-logging-ok \
  -d '*.DOMAIN' \
  -d DOMAIN
```

  a. Add the proper answers to the prompt questions. Specifically, ensure we
  give an email so they can notify us when our certs are going to expire.
4. The certbot dialogue will give you two separate txt entries you need to create as DNS records.
  a. We can do so by running `terraform apply
  -target=aws_route53_record.lets_encrypt_dns_challenge_mattjmcnaughton_(io|com)`
  from our `orchestration` terraform environment. When terraform prompts for the
  TXT entry for the record you aren't updating, you can just enter a nonsense
  value.
  b. You'll need to go back and forth with the certbot. Wait around a minute or
      so after creating the TXT record before asking the certbot to verify it.
5. Upload the certs to s3 (can use `docker cp` to copy off the container if we
   forgot to mount a volume).
  - Store in `s3://g-mattjmcnaughton/ssl/DOMAIN/...`
  - NOTE: Should we be storing these certs as encrypted on s3?
6. Shred the ssl certs on the host and kill the container we used to generate
   them.
7. Run `terraform destroy` in the orchestration directory.
8. [TBD] Launch new hosts to pull in the new certs. Alternatively, run
   orchestration script to force hosts to install new scripts.
9. Add remainder to update certs in X days (we should also be getting an email
   from Lets Encrypt).
