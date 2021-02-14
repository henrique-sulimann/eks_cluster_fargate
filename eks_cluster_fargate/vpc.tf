data "aws_availability_zones" "available" {}
module "vpc" {
    source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git//?ref=v2.70.0"
    name = "eks_cluster_vpc"
    cidr = "192.168.0.0/16"
    azs = data.aws_availability_zones.available.names
    private_subnets = ["192.168.1.0/24", "192.168.2.0/24"]
    public_subnets = ["192.168.3.0/24", "192.168.4.0/24"]
    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true
    public_subnet_tags = {
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/elb"                      = "1"
    }
    private_subnet_tags = {
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb"             = "1"
    }
}