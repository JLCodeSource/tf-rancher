resource "aws_lb_target_group_attachment" "rancher_private_443" {
    count = length(aws_instance.rancher_private.*.id)

    target_group_arn = module.elb.target_group_arns[0]
    target_id = aws_instance.rancher_private.*.id[count.index]
}

resource "aws_lb_target_group_attachment" "rancher_private_80" {
    count = length(aws_instance.rancher_private.*.id)

    target_group_arn = module.elb.target_group_arns[1]
    target_id = aws_instance.rancher_private.*.id[count.index]
}

/*
resource "aws_lb_target_group_attachment" "rancher_private_22" {
    count = length(aws_instance.rancher_private.*.id)

    target_group_arn = module.elb.target_group_arns[2]
    target_id = aws_instance.rancher_private.*.id[count.index]
}

 */