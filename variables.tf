variable "region" {
  default = "us-west-2"
}

data "aws_availability_zones" "available" {
}

variable "cidr" {
    default = "172.21.0.0/19"
}

variable "public_subnets" {
  default = ["172.21.0.0/21", "172.21.8.0/21", "172.21.16.0/21"]
}

variable "private_ips" {
    default = ["172.21.0.100", "172.21.8.100", "172.21.16.100"]
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
    default = "t3a.large"
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
