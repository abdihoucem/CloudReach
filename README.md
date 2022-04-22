# CloudReach

Option 1, I will deploy a three-tier application in AWS using Terraform.


![architecture](https://user-images.githubusercontent.com/35077338/164645757-f8cfdc32-045f-48fe-b5a8-335e2c798385.jpg)

This repository contains the following files:
- provider.tf: Initialize aws provider
- vpc.tf                 : create vpc
- subnet.tf              : create the different subnets
- security_groups.tf     : create the security groups
- auto-scaling.tf        : create the auto scaling groups
- internet-gateway.tf    : create internet gateway for connection internet
- load-balance.tf        : create web load balancing et application load balancer
- rds.tf                 : create data base
- certificat.tf          : create le certificat SSl for load balancer listener
- variable.tf            : create different variables
-cloudreachtest.sh       : script for test
