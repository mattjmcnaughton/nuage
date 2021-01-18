data "aws_route53_zone" "public" {
  name = "mattjmcnaughton.com."
}

# TODO: Perhaps these should be A record aliases as well?
resource "aws_route53_record" "env_blog" {
  zone_id = data.aws_route53_zone.public.zone_id
  name = "${local.name_prefix}-blog.mattjmcnaughton.com"
  type = "A"
  ttl = "30"
  records = [module.blog_ec2.public_ip[0]]
}

# We must use A record aliases - we can't have a CNAME for mattjmcnaughton.com
# in the mattjmcnaughton.com record set.
resource "aws_route53_record" "additional_alias_record" {
  count = length(var.additional_alias_records)
  zone_id = data.aws_route53_zone.public.zone_id
  name = var.additional_alias_records[count.index]
  type = "A"
  ttl = "30"
  records = [module.blog_ec2.public_ip[0]]
}
