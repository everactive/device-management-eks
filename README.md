# Device Management EKS

This repo defines a production-grade deployment of Everactive's fork of the [Canonical IoT Device Management reference architecture](https://ubuntu.com/blog/a-reference-architecture-for-secure-iot-device-management).

Canonical reference architecture is a great place to start, but we need something more robust for production usage. From the reference architecture, the most significant changes are. 

- Terraform based deployment to AWS
- Uses EKS instead of MicroK8S
- Uses Postgres RDS instead of Postgres Docker containers
- HTTPS support with Elastic Loadbalancers and AWS Certificate Manager

## Prerequisites

To deploy this project, you'll need the following. 

- Docker running locally
- AWS Account with access to create the required resources
- EKS Cluster in a VPC with public, private, and db subnet
- S3 bucket encrypted with a KMS key to store Terraform state

## Install

This repo comes with a Dockerfile with all the tooling needed to deploy this to your AWS infrastructure.

`make build/tools`

Once that is built, run.

`make console/tools`

This will drop you into the container with Terraform and other tools needed to run the deployment. This also mounts your local `~/.aws` and `~/.kube` files to share credentials. 

## Configuration

You'll need to fill in the required input variables defined in the [Terraform Inputs](#inputs). The make commands expect that these variables are defined in the [stacks folder](/stacks). For an example, see the [test-example.tfvars.json](stacks/test-example.tfvars.json).

Subprojects will also need to have a stack file with the same name in their `deploy/stacks` folders.

See their respective `test-example.tfvars.json` files for details.

- Iot Devicetwin [deploy/stacks](iot-devicetwin/deploy/stacks)
- Iot Identity [deploy/stacks](iot-identity/deploy/stacks)
- Iot Management [deploy/stacks](iot-management/deploy/stacks)

## Usage

### Your first deployment

Before you begin, run the `make update` to update the submodules. For the first deployment, you may want to verify what you are about to deploy using Terraform's plan feature. If you are confident everything is configured you can run `make STACK_NAME=test-example deploy/all`. Otherwise, you can step through the process like this.

1. First build and enter the tools container. `make build/tools` then `make console/tools`. 
1. Next run `make STACK_NAME=test-example init` then run `make STACK_NAME=test-example plan`
1. If you got no errors, run `make STACK_NAME=test-example apply.`

It may take some time for the AWS resources to be deployed. Once complete you'll can then run the `make STACK_NAME=test-example deploy/all.`

### Applying updates

To apply any updates, pull this repo. Then run `make update` to pull the latest version of the submodules. Then run `make STACK_NAME=test-example deploy/all`. 

### Tearing it down

*WARNING!* A complete teardown is very destructive. It's worth noting that RDS will create a snapshot of the DB before it deletes the RDS database resources just in case. 

Run the command `make destroy/all`. You will be prompted for approval before applying the changes. 

# Terraform Docs


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_kms_key.certs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.certs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_security_group.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [kubectl_manifest.certs_identity](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.certs_mqtt](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.certs_twin](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.external_db](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.namespace](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.pg_admin](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.pg_identity](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.pg_man](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.pg_twin](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [null_resource.certs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.db](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.pg_identity](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.pg_man](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.pg_twin](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_s3_bucket_object.ca_crt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket_object) | data source |
| [aws_s3_bucket_object.ca_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket_object) | data source |
| [aws_s3_bucket_object.devicetwin_crt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket_object) | data source |
| [aws_s3_bucket_object.devicetwin_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket_object) | data source |
| [aws_s3_bucket_object.mqtt_crt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket_object) | data source |
| [aws_s3_bucket_object.mqtt_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket_object) | data source |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_arn"></a> [cert\_arn](#input\_cert\_arn) | The AWS Certificate Manager ARN used by loadbalancers for https support | `string` | n/a | yes |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | n/a | `string` | `"The RDS Database subnet group name to use when provisioning the DB"` | no |
| <a name="input_docker_namespace"></a> [docker\_namespace](#input\_docker\_namespace) | The Docker repository namespace to use when pulling images | `string` | `"everactive/"` | no |
| <a name="input_docker_tag"></a> [docker\_tag](#input\_docker\_tag) | Docker used for pulling images from the Docker repo | `string` | `"latest"` | no |
| <a name="input_eks_cluster"></a> [eks\_cluster](#input\_eks\_cluster) | The AWS EKS Cluster to use | `string` | n/a | yes |
| <a name="input_hosted_zone"></a> [hosted\_zone](#input\_hosted\_zone) | The AWS Hosted Zone ID of the domain name | `string` | n/a | yes |
| <a name="input_identity_domain"></a> [identity\_domain](#input\_identity\_domain) | Domain name of the identity service | `string` | n/a | yes |
| <a name="input_ip_whitelist_private"></a> [ip\_whitelist\_private](#input\_ip\_whitelist\_private) | IP addresses allowed to access the load balancers of services that are considered private | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_ip_whitelist_public"></a> [ip\_whitelist\_public](#input\_ip\_whitelist\_public) | IP addresses allowed to access the load balancers of services that are considered public | `list` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_manager_domain"></a> [manager\_domain](#input\_manager\_domain) | Domain name of the management service | `string` | n/a | yes |
| <a name="input_mqtt_domain"></a> [mqtt\_domain](#input\_mqtt\_domain) | Domain name of the MQTT service | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to use when deploying config and services | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region to run in | `string` | `"us-east-1"` | no |
| <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name) | The name to give resources created | `string` | n/a | yes |
| <a name="input_state_bucket"></a> [state\_bucket](#input\_state\_bucket) | The S3 Bucket to store Terraform state | `string` | n/a | yes |
| <a name="input_state_key"></a> [state\_key](#input\_state\_key) | The S3 Bucket key to store Terraform state file | `string` | n/a | yes |
| <a name="input_state_kms_alias"></a> [state\_kms\_alias](#input\_state\_kms\_alias) | The alias of the KMS Encryption key used to encrypt the Terraform state bucket | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to any AWS resources created | `map(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_arn"></a> [cert\_arn](#output\_cert\_arn) | The AWS Certificate Manager ARN used by loadbalancers for https support |
| <a name="output_docker_namespace"></a> [docker\_namespace](#output\_docker\_namespace) | The Docker repository namespace to use when pulling images |
| <a name="output_docker_tag"></a> [docker\_tag](#output\_docker\_tag) | Docker used for pulling images from the Docker repo |
| <a name="output_eks_cluster"></a> [eks\_cluster](#output\_eks\_cluster) | The AWS EKS Cluster to use |
| <a name="output_hosted_zone"></a> [hosted\_zone](#output\_hosted\_zone) | The AWS Hosted Zone ID of the domain name |
| <a name="output_identity_domain"></a> [identity\_domain](#output\_identity\_domain) | Domain name of the identity service |
| <a name="output_ip_whitelist_private"></a> [ip\_whitelist\_private](#output\_ip\_whitelist\_private) | IP addresses allowed to access the load balancers of services that are considered private |
| <a name="output_ip_whitelist_public"></a> [ip\_whitelist\_public](#output\_ip\_whitelist\_public) | IP addresses allowed to access the load balancers of services that are considered public |
| <a name="output_manager_domain"></a> [manager\_domain](#output\_manager\_domain) | Domain name of the management service |
| <a name="output_mqtt_domain"></a> [mqtt\_domain](#output\_mqtt\_domain) | Domain name of the MQTT service |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Kubernetes namespace to use when deploying config and services |
| <a name="output_tags"></a> [tags](#output\_tags) | n/a |
<!-- END_TF_DOCS -->