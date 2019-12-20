data "aws_route53_zone" "mattjmcnaughton_com" {
  name = "mattjmcnaughton.com."
}

data "aws_route53_zone" "mattjmcnaughton_io" {
  name = "mattjmcnaughton.io."
}

resource "aws_route53_record" "lets_encrypt_dns_challenge_mattjmcnaughton_io" {
  zone_id = data.aws_route53_zone.mattjmcnaughton_io.zone_id
  name = "_acme-challenge.mattjmcnaughton.io"
  type = "TXT"
  ttl = "30"

  records = [
    var.mattjmcnaughton_io_dns_acme_challenge_txt
  ]
}

resource "aws_route53_record" "lets_encrypt_dns_challenge_mattjmcnaughton_com" {
  zone_id = data.aws_route53_zone.mattjmcnaughton_com.zone_id
  name = "_acme-challenge.mattjmcnaughton.com"
  type = "TXT"
  ttl = "30"

  records = [
    var.mattjmcnaughton_com_dns_acme_challenge_txt
  ]
}
