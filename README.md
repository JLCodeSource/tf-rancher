# tf-rancher

## Story So Far

### VPC 

main.tf relies on terraform-aws-modules/vpc/aws which creates a VPC based on variables.tf.
Currently, set in us-west-2, with 172.21.0.0/19 as the VPC.

There are 3 x /24 public_subnets - 172.21.(0/1/2).0/24 - and 3 x /21 private_subnets - 172.21.(8/16/24).0/21. Each of the 3 subnets for each of public/private are spread across the us-west-2a/2b/2c.

It creates NAT Gateways for each of the private subnets and a dedicated Network ACL for each (which currently do nothing).

### Security Groups

So far, we have the default sg, along with 3 others.
Default allows internal traffic and outgoing anywhere.
Internal_private allows ingress & egress from all to all in 172.21.0.0/19.
Outbound_internet allows all to anywhere.
ssh allows management from my IP

### ELB

elb & elb-attachment create a network elb pointing to the instances in the private subnets via 443.

### Instances

Each instance is set a private IP of 172.21.(0/1/2/8/16/24).100.

Public instances have a script that runs to update them and then create a script to copy ssh keys to the private nodes.

Private nodes update, install a couple of apps, including docker and then install rke. 

### Setup

On first login to a public subnet node; first action is to scp terraform-key to .ssh/id_rsa. Next run ./copy_keys.sh.

Connect into one of the private nodes and run:

/home/ubuntu/cluster_install.sh

## Post Setup

Copy:
kube_config_rancher-cluster.yml  
rancher-cluster.rkestate  
rancher-cluster.yml

To a safe place.

Run rancher-setup.sh and rancher-setup-part-2.sh.
Don't forget to update your hosts file!