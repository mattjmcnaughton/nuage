# We only have the one top level zone for `mattjmcnaughton.com`.
# It is our public facing zone.
#
# If the top level zones already exist (i.e. created by AWS when we purchased
# the domain), we can import them using `terraform import
# aws_route53_zone.mattjmcnaughton_com ZONE_ID`).
resource "aws_route53_zone" "mattjmcnaughton_com" {
  name = "mattjmcnaughton.com"
}

resource "aws_route53_zone" "worldsbestpug_com" {
  name = "worldsbestpug.com"
}

resource "aws_route53_zone" "thatsagoodpug_com" {
  name = "thatsagoodpug.com"
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

# Configuration for mattjmcnaughton.com to use fly.io

locals {
  blog_fly_io_hostname = "blog-hidden-brook-3429.fly.dev"

  # Run `fly ips list` from project root.
  blog_fly_io_ipv4 = "66.241.125.186"
  blog_fly_io_ipv6 = "2a09:8280:1::4b:bafb:0"

  blog_mattjmcnaughton_cnames = [
    "www.mattjmcnaughton.com",
    "blog.mattjmcnaughton.com",
  ]
}

# See https://fly.io/docs/networking/custom-domain/.
# We configure SSL via https://fly.io/docs/networking/custom-domain/#get-certified.

resource "aws_route53_record" "mattjmcnaughton_a" {
  zone_id = aws_route53_zone.mattjmcnaughton_com.zone_id
  name = "mattjmcnaughton.com"
  type = "A"
  ttl = "300"
  records = [
    local.blog_fly_io_ipv4
  ]
}

resource "aws_route53_record" "mattjmcnaughton_aaaa" {
  zone_id = aws_route53_zone.mattjmcnaughton_com.zone_id
  name = "mattjmcnaughton.com"
  type = "AAAA"
  ttl = "300"
  records = [
    local.blog_fly_io_ipv6
  ]
}

resource "aws_route53_record" "mattjmcnaughton_cname" {
  for_each = toset(local.blog_mattjmcnaughton_cnames)

  zone_id = aws_route53_zone.mattjmcnaughton_com.zone_id
  name = each.key
  type = "CNAME"
  ttl = "300"
  records = [
    local.blog_fly_io_hostname
  ]
}

# Configuration for Pug websites to use sr.ht pages

resource "aws_route53_record" "thatsagoodpug_a" {
  zone_id = aws_route53_zone.thatsagoodpug_com.zone_id
  name = "thatsagoodpug.com"
  type = "A"
  ttl = "300"
  records = [
    "46.23.81.157"
  ]
}

resource "aws_route53_record" "worldsbestpug_a" {
  zone_id = aws_route53_zone.worldsbestpug_com.zone_id
  name = "worldsbestpug.com"
  type = "A"
  ttl = "300"
  records = [
    "46.23.81.157"
  ]
}
