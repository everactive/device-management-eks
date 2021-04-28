
terraform {
  backend "s3" {
  }
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

locals {
  namespace            = var.namespace
  vpc_id               = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id
  security_group_ids   = data.aws_eks_cluster.cluster.vpc_config[0].security_group_ids
  default_sg           = data.aws_security_group.default.id
  db_subnet_group_name = var.db_subnet_group_name
  eks_cluster          = var.eks_cluster
  this_name            = var.resource_name
  identity_domain      = var.identity_domain
  manager_domain       = var.manager_domain
  mqtt_domain          = var.mqtt_domain
  docker_tag           = var.docker_tag
  hosted_zone          = var.hosted_zone
  docker_namespace     = var.docker_namespace
  tags                 = var.tags
  ip_whitelist_private = var.ip_whitelist_private
  ip_whitelist_public  = var.ip_whitelist_public
  cert_arn             = var.cert_arn
}

data "aws_eks_cluster" "cluster" {
  name = local.eks_cluster
}

data "aws_security_group" "default" {
  vpc_id = local.vpc_id
  name   = "default"
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster]
    command     = "aws"
  }
  load_config_file = false
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", local.eks_cluster]
    command     = "aws"
  }
}

resource "kubectl_manifest" "namespace" {
  override_namespace = local.namespace
  yaml_body = templatefile(
    "${path.module}/kubernetes/config/namespace.yaml",
    { NAMESPACE = local.namespace }
  )
}