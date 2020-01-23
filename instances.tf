resource "aws_instance" "rancher" {
    count = length(var.public_subnets)

    ami = var.ami
    instance_type = var.instance_type
    subnet_id = module.vpc.public_subnets[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    associate_public_ip_address = false
    private_ip = var.private_ips[count.index]
    #vpc_security_group_ids = [""]
    key_name = var.key_name

    tags = {
        Name = "rancher-${count.index}"
    }
}