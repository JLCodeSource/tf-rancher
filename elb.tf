module "elb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = "rancher-elb"
  load_balancer_type = "network"
  #security_groups = ["${module.internal_private_sg.this_security_group_id}"]
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  
  http_tcp_listeners = [
      {
          port                  = 443
          protocol              = "TCP"
          target_group_index    = 0
      },
       {
          port                  = 80
          protocol              = "TCP"
          target_group_index    = 1
      },
  ]

  target_groups = [
      { 
          name_prefix               = "r443t-"
          backend_protocol          = "TCP"
          backend_port              = 443
          target_type               = "instance"
          health_check  = {
              enabled               = true
              path                  = "/healthz"
              port                  = "80"
              healthy_threshold     = 3
              unhealthy_threshold   = 3
              timeout               = 6
              interval              = 10
              success_codes         = "200-399"
          }
      },
       { 
          name_prefix               = "r80t-"
          backend_protocol          = "TCP"
          backend_port              = 443
          target_type               = "instance"
          health_check  = {
              enabled               = true
              path                  = "/healthz"
              port                  = "traffic-port"
              healthy_threshold     = 3
              unhealthy_threshold   = 3
              timeout               = 6
              interval              = 10
              success_codes         = "200-399"
          }
      }
  ]

}

