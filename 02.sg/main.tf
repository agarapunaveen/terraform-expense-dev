module "db" {
  source = "../../terraform-security-group"
  project_name = var.project_name
  comman_tags = var.comman_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "db"
  environment = var.environment
}

module "backend" {
  source = "../../terraform-security-group"
  project_name = var.project_name
  comman_tags = var.comman_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "backend"
  environment = var.environment
}

module "frontend" {
  source = "../../terraform-security-group"
  project_name = var.project_name
  comman_tags = var.comman_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "frontend"
  environment = var.environment
}

module "bastion" {
  source = "../../terraform-security-group"
  project_name = var.project_name
  comman_tags = var.comman_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "bastion"
  environment = var.environment
}

module "ansible" {
  source = "../../terraform-security-group"
  project_name = var.project_name
  comman_tags = var.comman_tags
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "ansible"
  environment = var.environment
}

resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ansible.sg_id
}