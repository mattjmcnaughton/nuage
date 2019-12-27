data "aws_route53_zone" "public" {
  name = "mattjmcnaughton.com."
}

resource "aws_route53_record" "env_blog" {
  zone_id = data.aws_route53_zone.public.zone_id
  name = "${local.name_prefix}-blog.mattjmcnaughton.com"
  type = "CNAME"
  ttl = "300"
  records = [module.blog_elb.this_elb_dns_name]
}

# After I tear down kubernetes, add DNS entries for `blog.mattjmcnaughton.com`
# and `mattjmcnaughton.com` ONLY for production.
