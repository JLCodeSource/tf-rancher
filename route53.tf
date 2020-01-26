module "route53" {
  source  = "Aplyca/route53/aws"
  version = "0.2.0"
 
  domain = "rancher.tf.com"

  alias = {
    names = [
      ""
    ]
    values = [
      "${module.elb.this_lb_dns_name}"
    ]
    zones_id = [
      "${module.elb.this_lb_zone_id}"
    ]
  }

}

/* module "route53-alias" {
  source  = "cloudposse/route53-alias/aws"
  version = "0.4.0"
  # insert the 3 required variables here
  aliases         = ["rancher.tf.com.",]
  enabled         = true
  parent_zone_id  = "${module.route53.zone_id}"
  target_dns_name = "${module.elb.this_lb_dns_name}"
  target_zone_id  = "${module.elb.this_lb_zone_id}"
} */