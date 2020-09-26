data "aws_route53_zone" "public" {
  name = "mattjmcnaughton.com."
}

# TODO: Perhaps these should be A record aliases as well?
resource "aws_route53_record" "env_blog" {
  zone_id = data.aws_route53_zone.public.zone_id
  name = "${local.name_prefix}-blog.mattjmcnaughton.com"
  type = "CNAME"
  ttl = "300"
  records = [var.main_aws_lb_dns_name]
}

# We must use A record aliases - we can't have a CNAME for mattjmcnaughton.com
# in the mattjmcnaughton.com record set.
resource "aws_route53_record" "additional_alias_record" {
  count = length(var.additional_alias_records_for_lb)
  zone_id = data.aws_route53_zone.public.zone_id
  name = var.additional_alias_records_for_lb[count.index]
  type = "A"

  alias {
    name = var.main_aws_lb_dns_name
    zone_id = var.main_aws_lb_zone_id
    evaluate_target_health = false
  }
}
