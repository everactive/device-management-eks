resource "null_resource" "certs" {
  provisioner "local-exec" {
    command     = <<EOF
        bash bin/gencerts.sh
        EOF
    interpreter = ["/bin/bash", "-c"]
  }
}


resource "aws_kms_key" "certs" {
  description = "Certs for ${local.this_name}"
  tags = merge({
    Name = "${local.this_name}-certs"
  }, local.tags)
}

resource "aws_s3_bucket" "certs" {
  bucket = "${local.this_name}-certs"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.certs.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  force_destroy = true
  tags          = local.tags
}

locals {
  cert_files = [
    "ca.crt",
    "ca.key",
    "ca.srl",
    "devicetwin.crt",
    "devicetwin.key",
    "mqtt.crt",
  "mqtt.key"]
}

resource "aws_s3_bucket_object" "cert" {
  count        = length(local.cert_files)
  depends_on   = [null_resource.certs]
  key          = local.cert_files[count.index]
  bucket       = aws_s3_bucket.certs.id
  source       = "${path.module}/certs/${local.cert_files[count.index]}"
  tags         = local.tags
  content_type = "text/*"
  lifecycle {
    ignore_changes = [source]
  }
}

data "aws_s3_bucket_object" "ca_crt" {
  depends_on = [aws_s3_bucket_object.cert]
  bucket     = aws_s3_bucket.certs.bucket
  key        = "ca.crt"
}

data "aws_s3_bucket_object" "ca_key" {
  depends_on = [aws_s3_bucket_object.cert]
  bucket     = aws_s3_bucket.certs.bucket
  key        = "ca.key"
}

data "aws_s3_bucket_object" "devicetwin_key" {
  depends_on = [aws_s3_bucket_object.cert]
  bucket     = aws_s3_bucket.certs.bucket
  key        = "devicetwin.key"
}

data "aws_s3_bucket_object" "devicetwin_crt" {
  depends_on = [aws_s3_bucket_object.cert]
  bucket     = aws_s3_bucket.certs.bucket
  key        = "devicetwin.crt"
}

data "aws_s3_bucket_object" "mqtt_crt" {
  depends_on = [aws_s3_bucket_object.cert]
  bucket     = aws_s3_bucket.certs.bucket
  key        = "mqtt.crt"
}

data "aws_s3_bucket_object" "mqtt_key" {
  depends_on = [aws_s3_bucket_object.cert]
  bucket     = aws_s3_bucket.certs.bucket
  key        = "mqtt.key"
}
