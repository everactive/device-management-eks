provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS Region to run in"
  default     = "us-east-1"
}

variable "ip_whitelist_public" {
  description = "IP addresses allowed to access the load balancers of services that are considered public"
  default     = ["0.0.0.0/0"]
}

variable "ip_whitelist_private" {
  description = "IP addresses allowed to access the load balancers of services that are considered private"
  default     = ["0.0.0.0/0"]
}

variable "db_subnet_group_name" {
  default = "The RDS Database subnet group name to use when provisioning the DB"
  type    = string
}

variable "docker_namespace" {
  description = "The Docker repository namespace to use when pulling images"
  default     = "everactive/"
}

variable "eks_cluster" {
  description = "The AWS EKS Cluster to use"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to use when deploying config and services"
  type        = string
}

variable "hosted_zone" {
  description = "The AWS Hosted Zone ID of the domain name"
  type        = string
}

variable "docker_tag" {
  description = "Docker used for pulling images from the Docker repo"
  default     = "latest"
}

variable "mqtt_domain" {
  description = "Domain name of the MQTT service"
  type        = string
}

variable "manager_domain" {
  description = "Domain name of the management service"
  type        = string
}

variable "identity_domain" {
  description = "Domain name of the identity service"
  type        = string
}

variable "cert_arn" {
  description = "The AWS Certificate Manager ARN used by loadbalancers for https support"
  type        = string
}

variable "tags" {
  description = "Tags to apply to any AWS resources created"
  type        = map(any)
}

variable "state_bucket" {
  description = "The S3 Bucket to store Terraform state"
  type        = string
}

variable "state_key" {
  description = "The S3 Bucket key to store Terraform state file"
  type        = string
}

variable "resource_name" {
  description = "The name to give resources created"
  type        = string
}

variable "state_kms_alias" {
  description = "The alias of the KMS Encryption key used to encrypt the Terraform state bucket"
  type        = string
}