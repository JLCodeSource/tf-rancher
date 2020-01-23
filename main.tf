module "vpc" {
  source  = "../terraform-aws-modules/terraform-aws-vpc/"

  name                 = var.vpc_name
  cidr                 = var.cidr
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = var.public_subnets
  #private_subnets      = var.private_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true
  public_dedicated_network_acl = true
  #private_dedicated_network_acl = true
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  /*private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }*/
  
}



