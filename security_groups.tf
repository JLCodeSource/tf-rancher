
resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      name = "default rancher sg"
  }
}
 
module "internal_private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"

    name = "internal_private_sg"
    description = "Security group for internal traffic from public to private"
    vpc_id = module.vpc.vpc_id

    ingress_cidr_blocks = ["${var.cidr}"]
    ingress_rules = ["all-all"]
    egress_cidr_blocks = ["${var.cidr}"]
    egress_rules = ["all-all"]
}

module "outbound_internet_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"

    name = "outbound_internet_sg"
    description = "Security group for external traffic"
    vpc_id = module.vpc.vpc_id

    egress_cidr_blocks = ["0.0.0.0/0"]
    egress_rules = ["all-all"]
}

module "ssh_sg" {
    source  = "terraform-aws-modules/security-group/aws"
    version = "3.4.0"

    name = "ssh_sg"
    description = "Security group for ssh into public subnet"
    vpc_id = module.vpc.vpc_id

    ingress_cidr_blocks = ["${var.mgmt-ip}"]
    ingress_rules = ["ssh-tcp"]
}


