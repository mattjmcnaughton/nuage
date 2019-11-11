data "aws_route53_zone" "public" {
  name = "mattjmcnaughton.com."
}

resource "aws_route53_record" "bastion" {
  zone_id = data.aws_route53_zone.public.zone_id
  name = "${local.name_prefix}-bastion.mattjmcnaughton.com"
  type = "A"
  ttl = "300"
  records = module.bastion_host.public_ip
}
