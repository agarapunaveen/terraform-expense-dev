module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
  subnet_id              = element(split(",",data.aws_ssm_parameter.backend_subnet_ids.value),0)
  ami=data.aws_ami.ubuntu.id

  tags = merge(
    var.comman_tags,
    {
    Name="${var.project_name}-${var.environment}-backend"
  }
  )
}

module "frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.public_sg_id.value]
  subnet_id              = element(split(",",data.aws_ssm_parameter.public_subnet_ids.value),0)
  ami=data.aws_ami.ubuntu.id

  tags = merge(
    var.comman_tags,
    {
    Name="${var.project_name}-${var.environment}-frontend"
  }
  )
}

module "ansible" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-${var.environment}"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.ansible_sg_id.value]
  subnet_id              = element(split(",",data.aws_ssm_parameter.public_subnet_ids.value),0)
  ami=data.aws_ami.ubuntu.id
  user_data = file("./expense.sh")
  tags = merge(
    var.comman_tags,
    {
    Name="${var.project_name}-${var.environment}-ansible"
  }
  )
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "backend"
      type    = "A"
      ttl = 1
      records = [
        module.backend.private_ip
      ]
    },
    {
      name    = "frontend"
      type    = "A"
      ttl     = 1
      records = [
        module.frontend.private_ip
      ]
    },
     {
      name    = ""
      type    = "A"
      ttl     = 1
      records = [
        module.frontend.public_ip
      ]
    },
  ]
}