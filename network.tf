provider "aws" {
  region  = "eu-central-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "provectus"
  cidr = "10.0.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = false
  enable_vpn_gateway = true
  reuse_nat_ips       = true                    # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = "${aws_eip.nat.*.id}"   # <= IPs specified here as input to the module


  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

  
resource "aws_eip" "nat" {
  count = 3

  vpc = true
}
