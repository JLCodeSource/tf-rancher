module "ssh_sg" {
    source = "../terraform-aws-modules/terraform-aws-security-group"

    name = "ssh-sg"
    description = "Security group for ssh into public subnet"
    vpc_id = module.vpc.vpc_id

    ingress_cidr_blocks = ["${var.mgmt-ip}"]
    ingress_rules = ["ssh-tcp"]
}