data "aws_route53_zone" "public" {
  name = "mattjmcnaughton.com."
}

# TODO: Perhaps these should be A record aliases as well?
resource "aws_route53_record" "env_blog" {
  zone_id = data.aws_route53_zone.public.zone_id
  name = "${local.name_prefix}-blog.mattjmcnaughton.com"
  type = "CNAME"
  ttl = "300"
  records = [module.blog_elb.this_elb_dns_name]
}

resource "aws_route53_record" "additional_alias_record" {
  count = length(var.additional_alias_records_for_elb)
  zone_id = data.aws_route53_zone.public.zone_id
  name = var.additional_alias_records_for_elb[count.index]
  type = "A"

  alias {
    name = module.blog_elb.this_elb_dns_name
    zone_id = module.blog_elb.this_elb_zone_id
    evaluate_target_health = false
  }
}
