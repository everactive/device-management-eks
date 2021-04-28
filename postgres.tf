resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = "_%"
}

resource "aws_security_group" "eks" {
  description = "EKS Access"
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = [
        "::/0",
      ]
      description     = ""
      from_port       = 0
      protocol        = "-1"
      prefix_list_ids = []
      security_groups = []
      to_port         = 0
      self            = false
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      description      = ""
      from_port        = 5432
      protocol         = "tcp"
      prefix_list_ids  = []
      security_groups  = []
      to_port          = 5432
      self             = false
    },
  ]
  name                   = "${local.this_name}-eks"
  revoke_rules_on_delete = false
  tags                   = local.tags
  vpc_id                 = local.vpc_id
}

resource "aws_db_instance" "db" {
  allocated_storage          = 10
  engine                     = "postgres"
  engine_version             = "10.15"
  identifier                 = local.this_name
  instance_class             = "db.t2.small"
  storage_type               = "gp2"
  name                       = "main"
  password                   = random_password.db.result
  username                   = "admin_user"
  backup_retention_period    = 7
  backup_window              = "04:00-04:30"
  maintenance_window         = "sun:04:30-sun:05:30"
  auto_minor_version_upgrade = true
  final_snapshot_identifier  = local.this_name
  skip_final_snapshot        = false
  copy_tags_to_snapshot      = true
  multi_az                   = false
  port                       = 5432
  vpc_security_group_ids = [local.default_sg,
  aws_security_group.eks.id]
  db_subnet_group_name = local.db_subnet_group_name
  tags = merge({
    Name = local.this_name },
  local.tags)
}