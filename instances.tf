resource "local_file" "user_data_public" {
    count = length(var.public_subnets)
    content = templatefile("user-data-public.sh.tpl", {
        private_key = var.rancher_private_key
        public_key = var.rancher_public_key
        },)
    filename = "user-data-public-${var.node_name}-${count.index}.sh"
}

resource "aws_instance" "rancher_public" {
    count = length(var.public_subnets)

    ami = var.ami
    instance_type = var.instance_type[0]
    subnet_id = module.vpc.public_subnets[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    private_ip = var.private_ips_public[count.index]
    vpc_security_group_ids = [
        "${module.ssh_sg.this_security_group_id}",
        "${module.internal_private_sg.this_security_group_id}",
        "${module.outbound_internet_sg.this_security_group_id}",
        ]
    key_name = var.frontend_key_name
    user_data = file("user-data-public-${var.node_name}-${count.index}.sh")
    tags = {
        Name = "rancher-bastion-public-${count.index}"
    }
}

resource "local_file" "user_data_private" {
    count = length(var.private_subnets)
    content = templatefile("user-data-private.sh.tpl", {
        private_key = var.rancher_private_key
        public_key = var.rancher_public_key
        domain_name = var.domain_name
        },)
    filename = "user-data-private-${var.node_name}-${count.index}.sh"
}


resource "aws_instance" "rancher_private" {
    count = length(var.private_subnets)

    ami = var.ami
    instance_type = var.instance_type[1]
    subnet_id = module.vpc.private_subnets[count.index]
    availability_zone = data.aws_availability_zones.available.names[count.index]
    private_ip = var.private_ips_private[count.index]
    vpc_security_group_ids = [
        "${module.internal_private_sg.this_security_group_id}",
        "${module.outbound_internet_sg.this_security_group_id}",
        "${module.inbound_https_sg.this_security_group_id}",
        "${module.inbound_http_sg.this_security_group_id}",
        "${module.internal_rancher_sg.this_security_group_id}",
    ]

    key_name = var.backend_key_name
    user_data = file("user-data-private-${var.node_name}-${count.index}.sh")
    tags = {
        Name = "rancher-private-${count.index}"
    }

    root_block_device {
        volume_type = "gp2"
        volume_size = 50
    }
}

output "rancher-public-instance-ids" {
    value = aws_instance.rancher_public.*.id
}

output "rancher-private-instance-ids" {
    value = aws_instance.rancher_private.*.id
}

output "rancher-public-instance-external-ips" {
    value = aws_instance.rancher_public.*.public_ip
}

output "rancher-public-instance-internal-ips" {
    value = aws_instance.rancher_public.*.private_ip
}

output "rancher-private-instance-internal-ips" {
    value = aws_instance.rancher_private.*.private_ip
}

output "rancher-private-instance-external-ips" {
    value = aws_instance.rancher_private.*.public_ip
}
