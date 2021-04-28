resource "kubectl_manifest" "certs_twin" {
  override_namespace = local.namespace
  yaml_body = templatefile("${path.module}/kubernetes/config/devicetwin-certs.yaml",
    { CRT_B64     = base64encode(data.aws_s3_bucket_object.ca_crt.body)
      SRV_KEY_B64 = base64encode(data.aws_s3_bucket_object.devicetwin_key.body)
  SRV_CRT_B64 = base64encode(data.aws_s3_bucket_object.devicetwin_crt.body) })
}

resource "kubectl_manifest" "certs_identity" {
  override_namespace = local.namespace
  yaml_body = templatefile("${path.module}/kubernetes/config/identity-certs.yaml",
    { CRT_B64 = base64encode(data.aws_s3_bucket_object.ca_crt.body)
  KEY_B64 = base64encode(data.aws_s3_bucket_object.ca_key.body) })
}

resource "kubectl_manifest" "certs_mqtt" {
  override_namespace = local.namespace
  yaml_body = templatefile("${path.module}/kubernetes/config/mqtt-certs.yaml",
    { CRT_B64     = base64encode(data.aws_s3_bucket_object.ca_crt.body)
      SRV_KEY_B64 = base64encode(data.aws_s3_bucket_object.mqtt_key.body)
  SRV_CRT_B64 = base64encode(data.aws_s3_bucket_object.mqtt_crt.body) })
}