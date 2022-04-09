# We only have the one top level zone for `mattjmcnaughton.com`.
# It is our public facing zone. All `dev`, `staging`, `prod`, etc...
# delinieations should occur in the private `.io` zone.
#
# If the top level zones already exist (i.e. created by AWS when we purchased
# the domain), we can import them using `terraform import
# aws_route53_zone.mattjmcnaughton_com ZONE_ID`).
resource "aws_route53_zone" "mattjmcnaughton_com" {
  name = "mattjmcnaughton.com"
}

resource "aws_route53_zone" "mattjmcnaughton_io" {
  name = "mattjmcnaughton.io"
}

resource "aws_route53_zone" "go_carbon_neutral_com" {
  name = "go-carbon-neutral.com"
}

# @TODO(mattjmcnaughton) We could extract the `aws_route53_zone` and
# `aws_route53_record` necessary for creating a subdomain into a tested module.
#
# @TODO(mattjmcnaughton) It is also a fair question whether defining these
# route53 zones/nameservice records should live in the `global` terraform
# directory or in the respective environment directories. I'm going to leave it
# in global for now... but it may make sense to change it later.
resource "aws_route53_zone" "dev_mattjmcnaughton_io" {
  name = "dev.mattjmcnaughton.io"
}

resource "aws_route53_record" "dev_mattjmcnaughton_io_ns" {
  zone_id = aws_route53_zone.mattjmcnaughton_io.zone_id
  name = "dev.mattjmcnaughton.io"
  type = "NS"
  ttl = "30"

  records = [
    aws_route53_zone.dev_mattjmcnaughton_io.name_servers.0,
    aws_route53_zone.dev_mattjmcnaughton_io.name_servers.1,
    aws_route53_zone.dev_mattjmcnaughton_io.name_servers.2,
    aws_route53_zone.dev_mattjmcnaughton_io.name_servers.3,
  ]
}

resource "aws_route53_zone" "staging_mattjmcnaughton_io" {
  name = "staging.mattjmcnaughton.io"
}

resource "aws_route53_record" "staging_mattjmcnaughton_io_ns" {
  zone_id = aws_route53_zone.mattjmcnaughton_io.zone_id
  name = "staging.mattjmcnaughton.io"
  type = "NS"
  ttl = "30"

  records = [
    aws_route53_zone.staging_mattjmcnaughton_io.name_servers.0,
    aws_route53_zone.staging_mattjmcnaughton_io.name_servers.1,
    aws_route53_zone.staging_mattjmcnaughton_io.name_servers.2,
    aws_route53_zone.staging_mattjmcnaughton_io.name_servers.3,
  ]
}

resource "aws_route53_zone" "prod_mattjmcnaughton_io" {
  name = "prod.mattjmcnaughton.io"
}

resource "aws_route53_record" "prod_mattjmcnaughton_io_ns" {
  zone_id = aws_route53_zone.mattjmcnaughton_io.zone_id
  name = "prod.mattjmcnaughton.io"
  type = "NS"
  ttl = "30"

  records = [
    aws_route53_zone.prod_mattjmcnaughton_io.name_servers.0,
    aws_route53_zone.prod_mattjmcnaughton_io.name_servers.1,
    aws_route53_zone.prod_mattjmcnaughton_io.name_servers.2,
    aws_route53_zone.prod_mattjmcnaughton_io.name_servers.3,
  ]
}

resource "aws_route53_zone" "global_mattjmcnaughton_io" {
  name = "global.mattjmcnaughton.io"
}

resource "aws_route53_record" "global_mattjmcnaughton_io_ns" {
  zone_id = aws_route53_zone.mattjmcnaughton_io.zone_id
  name = "global.mattjmcnaughton.io"
  type = "NS"
  ttl = "30"

  records = [
    aws_route53_zone.global_mattjmcnaughton_io.name_servers.0,
    aws_route53_zone.global_mattjmcnaughton_io.name_servers.1,
    aws_route53_zone.global_mattjmcnaughton_io.name_servers.2,
    aws_route53_zone.global_mattjmcnaughton_io.name_servers.3,
  ]
}

# Configuration for fastmail to send email via mattjmcnaughton.com.

resource "aws_route53_record" "fastmail_mx" {
  zone_id = aws_route53_zone.mattjmcnaughton_com.zone_id
  name = "mattjmcnaughton.com"
  type = "MX"
  ttl = "300"
  records = [
    "10 in1-smtp.messagingengine.com",
    "20 in2-smtp.messagingengine.com"
  ]
}


# CNAMES to support DKIM

resource "aws_route53_record" "fastmail_dkim_1" {
  zone_id = aws_route53_zone.mattjmcnaughton_com.zone_id
  name = "fm1._domainkey"
  type = "CNAME"
  ttl = "300"
  records = [
    "fm1.mattjmcnaughton.com.dkim.fmhosted.com"
  ]
}

resource "aws_route53_record" "fastmail_dkim_2" {
  zone_id = aws_route53_zone.mattjmcnaughton_com.zone_id
  name = "fm2._domainkey"
  type = "CNAME"
  ttl = "300"
  records = [
    "fm2.mattjmcnaughton.com.dkim.fmhosted.com"
  ]
}

resource "aws_route53_record" "fastmail_dkim_3" {
  zone_id = aws_route53_zone.mattjmcnaughton_com.zone_id
  name = "fm3._domainkey"
  type = "CNAME"
  ttl = "300"
  records = [
    "fm3.mattjmcnaughton.com.dkim.fmhosted.com"
  ]
}

# TXT to support SPF

resource "aws_route53_record" "fastmail_spf" {
  zone_id = aws_route53_zone.mattjmcnaughton_com.zone_id
  name = "mattjmcnaughton.com"  # Route53 is weird about us using "@" so specify full domain.
  type = "TXT"
  ttl = "300"
  records = [
    "v=spf1 include:spf.messagingengine.com ?all"
  ]
}
