

output "id"{
    value = module.vpc.vpc_id
}
output "subnet_id" {
  value = module.vpc.public_subnet_ids

}