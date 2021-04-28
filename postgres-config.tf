resource "kubectl_manifest" "external_db" {
  override_namespace = local.namespace
  yaml_body = templatefile(
    "${path.module}/kubernetes/config/external-db.yaml",
    { HOST = aws_db_instance.db.address }
  )
}

resource "kubectl_manifest" "pg_admin" {
  override_namespace = local.namespace
  yaml_body = templatefile(
    "${path.module}/kubernetes/config/postgres.yaml",
    { CONFIG_MAP_POSTFIX = "admin"
      SERVICE_DB_NAME    = aws_db_instance.db.name
      USERNAME           = aws_db_instance.db.username
      PASSWORD           = random_password.db.result
    HOST = "postgres" }
  )
}

resource "random_password" "pg_man" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubectl_manifest" "pg_man" {
  override_namespace = local.namespace
  yaml_body = templatefile(
    "${path.module}/kubernetes/config/postgres.yaml",
    { CONFIG_MAP_POSTFIX = "man"
      SERVICE_DB_NAME    = "management"
      USERNAME           = "man_manager"
      PASSWORD           = random_password.pg_man.result
    HOST = "postgres" }
  )
}

resource "random_password" "pg_identity" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubectl_manifest" "pg_identity" {
  override_namespace = local.namespace
  yaml_body = templatefile(
    "${path.module}/kubernetes/config/postgres.yaml",
    { CONFIG_MAP_POSTFIX = "identity"
      SERVICE_DB_NAME    = "identity"
      USERNAME           = "identity_manager"
      PASSWORD           = random_password.pg_identity.result
    HOST = "postgres" }
  )
}

resource "random_password" "pg_twin" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "kubectl_manifest" "pg_twin" {
  override_namespace = local.namespace
  yaml_body = templatefile(
    "${path.module}/kubernetes/config/postgres.yaml",
    {
      CONFIG_MAP_POSTFIX = "twin"
      SERVICE_DB_NAME    = "devicetwin"
      USERNAME           = "twin_manager"
      PASSWORD           = random_password.pg_twin.result
    HOST = "postgres" }
  )
}