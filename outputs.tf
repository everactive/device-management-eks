output "ip_whitelist_public" {
  description = "IP addresses allowed to access the load balancers of services that are considered public"
  value       = local.ip_whitelist_public
}

output "ip_whitelist_private" {
  description = "IP addresses allowed to access the load balancers of services that are considered private"
  value       = local.ip_whitelist_private
}

output "tags" {
  value = local.tags
}

output "docker_namespace" {
  description = "The Docker repository namespace to use when pulling images"
  value       = local.docker_namespace
}

output "eks_cluster" {
  description = "The AWS EKS Cluster to use"
  value       = local.eks_cluster
}

output "namespace" {
  description = "Kubernetes namespace to use when deploying config and services"
  value       = local.namespace
}

output "hosted_zone" {
  description = "The AWS Hosted Zone ID of the domain name"
  value       = local.hosted_zone
}

output "cert_arn" {
  description = "The AWS Certificate Manager ARN used by loadbalancers for https support"
  value       = local.cert_arn
}

output "docker_tag" {
  description = "Docker used for pulling images from the Docker repo"
  value       = local.docker_tag
}

output "mqtt_domain" {
  description = "Domain name of the MQTT service"
  value       = local.mqtt_domain
}

output "manager_domain" {
  description = "Domain name of the management service"
  value       = local.manager_domain
}

output "identity_domain" {
  description = "Domain name of the identity service"
  value       = local.identity_domain
}