This is a deployment of an AWS VPC with 3 subnets deployed in different 3 Availability Zones.
One subnet is deployed for egress and the other 2 which could house your web apps have a NAT Gateway.

First install Terraform on the region cloudshell that you will Deploy the VPC. How? In the link below:
https://github.com/shingieuihos/terraform-aws-cloudshell-setup.git


Terraform Configuration to Deploy "Shingi-North-Virginia-Office-1" VPC
VPC: 10.0.0.0/16 with IPv6 support.

Subnets:
web_servers and accounting: public subnets with IPv4.
operations: private IPv6-enabled subnet.
Internet Gateway: for web_servers and accounting.
Egress-Only Gateway: for IPv6-only outbound traffic from operations.

Public Route Table (RTShingi-Public):
SNVO1web-servers and SNVO1accounting subnets
Routed through Internet Gateway

Private Route Table (RTShingi-Private):
SNVO1operations subnet
IPv4 via NAT Gateway
IPv6 via Egress-Only Gateway
