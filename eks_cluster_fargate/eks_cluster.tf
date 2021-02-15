module "eks_cluster" {
    source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git//?ref=v14.0.0"
    cluster_name = local.cluster_name
    cluster_version="1.18"
    cluster_endpoint_private_access = true
    cluster_endpoint_private_access_cidrs =  module.vpc.private_subnets_cidr_blocks 
    cluster_create_endpoint_private_access_sg_rule = true
    create_fargate_pod_execution_role = true
    attach_worker_cni_policy = true
    enable_irsa = true
    fargate_pod_execution_role_name = "${local.cluster_name}_pod_execution_role"
    subnets = module.vpc.private_subnets
    vpc_id = module.vpc.vpc_id 
    tags = {
    Environment = "test"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }
    fargate_profiles = {
      wab-interaxa-adapter = {
        namespace = "default"
      }
      kube-system = {
        namespace = "kube-system"
      }   
    } 
    depends_on = [ module.vpc ]
}
resource "null_resource" "coredns" {
  depends_on = [ module.eks_cluster ]
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${local.cluster_name}"
  }
  provisioner "local-exec" {
    command = "kubectl patch deployment coredns -n kube-system --type json -p='[{'op': 'remove', 'path': '/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type'}]'"
  }
  provisioner "local-exec" {
    command = "kubectl rollout restart -n kube-system deployment coredns"
  }
}
module "alb_ingress_controller" {
  source = "git::https://github.com/iplabs/terraform-kubernetes-alb-ingress-controller.git//?ref=v3.4.0"
  k8s_cluster_type = "eks"
  k8s_namespace = "kube-system"
  k8s_replicas = 3
  aws_region_name = var.region
  k8s_cluster_name = local.cluster_name
  depends_on = [ null_resource.coredns ] 
} 
