An example ec2 instance provisioned with [terraform](https://terraform.io).
The point here is to illustrate the basic functioning of **VPC components** and **routing** (IPv4 only).
Mainly NACL's are intended describe routing VPC wide, whereas security groups are used to
attach routing to particular resources. More on basic networking components
[here](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Networking.html).    

The `terraform init` and `terraform apply` will provision necessary networking resources
and an instance latest ubuntu AMI in the aws cloud.

After a successful provisioning, connect to the instance
`ssh -i path/to/private_key ubuntu@$(terraform output public_eip)`  

#### Resources include:
 - VPC with a cird range of `10.0.0.0/16`, a public subnet associated
 with a route table pointing to an internet gateway, a NACL, security group, elastic ip .
 The example VPC allows incoming TCP requests on port 22 from (your) local IP
 and allows all outbound traffic from the provisioned instance.
 - The [ec2.tf](ec2.tf) file is used to create aws key pair (our public key),
 retrieve the latest ubuntu AMI id (image maintained by Canonical) and the instance itself.
 - The [vars.tf](vars.tf) does not define credentials profile and region which needs to either 
 added typed when terraform apply is run.
