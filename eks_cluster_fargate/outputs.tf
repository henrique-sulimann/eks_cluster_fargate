output "cluster_endpoint" {
    value = module.eks_cluster.cluster_endpoint
}
output "cluster_security_group_id" {
    value = module.eks_cluster.cluster_security_group_id
}
output "kubectl_config" {
    value = module.eks_cluster.kubeconfig
}
output "config_map_aws_auth" {
    value = module.eks_cluster.config_map_aws_auth
}
output "region" {
    value = var.region
}
output "cluster_name" {
    value = var.cluster_name
}
output "oidc_arn" {
    value = module.eks_cluster.oidc_provider_arn
}
output "cluster_oidc_issuer_url" {
    value = module.eks_cluster.cluster_oidc_issuer_url
}
output "fargate_profile_arns" {
  description = "Outputs from node groups"
  value       = module.eks_cluster.fargate_profile_arns
}
output "fargate_iam_role_arn" {
    value = module.eks_cluster.fargate_iam_role_arn
} 