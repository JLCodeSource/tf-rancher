resource "aws_instance" "rancher_public" {
    count = length(var.public_subnets)

    ami = var.ami
    instance_type = var.instance_type[0]
    subnet_id = module.vpc.public_subnets[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    private_ip = var.private_ips_public[count.index]
    vpc_security_group_ids = ["${module.ssh_sg.this_security_group_id}"]
    key_name = var.key_name
    
    tags = {
        Name = "rancher-bastion-public-${count.index}"
    }
}

resource "aws_instance" "rancher_private" {
    count = length(var.private_subnets)

    ami = var.ami
    instance_type = var.instance_type[1]
    subnet_id = module.vpc.private_subnets[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    private_ip = var.private_ips_private[count.index]
    #vpc_security_group_ids = [""]
    key_name = var.key_name

    tags = {
        Name = "rancher-private-${count.index}"
    }
}