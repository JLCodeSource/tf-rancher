variable "region" {
  default = "us-west-2"
}

variable "domain_name" {
  default = "rancher.tf-support.com"
}

data "aws_availability_zones" "available" {
}

variable "mgmt-ip" {
  default = "95.147.105.79/32"
}

variable "cidr" {
    default = "172.21.0.0/19"
}

variable "public_subnets" {
  default = ["172.21.0.0/24", "172.21.1.0/24", "172.21.2.0/24"]
}

variable "private_subnets" {
  default = ["172.21.8.0/21", "172.21.16.0/21", "172.21.24.0/21"]
}

variable "private_ips_public" {
    default = ["172.21.0.100", "172.21.1.100", "172.21.2.100"]
}

variable "private_ips_private" {
    default = ["172.21.8.100", "172.21.16.100", "172.21.24.100"]
}

variable "vpc_name" {
  default = "tf-rancher"
}

variable "key_name" {
    default = "terraform-key"
}

variable "ami" {
    default  = "ami-06d51e91cea0dac8d"
}

variable "instance_type" {
    description = "Instance type is a list of types, public then private"
    default = ["t3a.micro", "t3a.large"]
}

variable "cluster_name" {
    default = "tf-rancher"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "AWS_ACC_NUM",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::AWS_ACC_NUM:role/k8s-rancher"
      username = "k8s-rancher"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::AWS_ACC_NUM:user/firstname.lastname@tf.com"
      username = "username"
      groups   = ["system:masters"]
    },
  ]
}
