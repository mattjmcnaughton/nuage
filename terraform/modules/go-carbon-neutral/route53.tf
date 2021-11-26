data "aws_route53_zone" "go_carbon_neutral" {
  name = "go-carbon-neutral.com."
}

# TODO: Perhaps these should be A record aliases as well?
resource "aws_route53_record" "env_go_carbon_neutral" {
  zone_id = data.aws_route53_zone.go_carbon_neutral.zone_id
  name = "${local.name_prefix}-site.go-carbon-neutral.com"
  type = "A"
  ttl = "30"
  records = [module.go_carbon_neutral_ec2.public_ip[0]]
}

# We must use A record aliases - we can't have a CNAME for go-carbon-neutral.com
# in the go-carbon-neutral.com record set.
resource "aws_route53_record" "additional_alias_record" {
  count = length(var.additional_alias_records)
  zone_id = data.aws_route53_zone.go_carbon_neutral.zone_id
  name = var.additional_alias_records[count.index]
  type = "A"
  ttl = "30"
  records = [module.go_carbon_neutral_ec2.public_ip[0]]
}
