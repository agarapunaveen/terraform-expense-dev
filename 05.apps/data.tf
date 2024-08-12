data "aws_ssm_parameter" "backend_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private_subnet_ids"
}
data "aws_ssm_parameter" "backend_sg_id" {
  name = "/${var.project_name}/${var.environment}/backend_sg_id"
}
data "aws_ami" "ubuntu" {
  most_recent      = true
  owners           = ["973714476881"]
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}
data "aws_ssm_parameter" "public_sg_id" {
  name = "/${var.project_name}/${var.environment}/frontend_sg_id"
}

data "aws_ssm_parameter" "ansible_sg_id" {
  name = "/${var.project_name}/${var.environment}/ansible_sg_id"
}