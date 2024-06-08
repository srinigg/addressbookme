output "buildserver-ip" {
  value = module.myec2.ec2.public_ip

}

output "webserver-ip" {
  value = module.myec21.ec2.public_ip

}

# output "subnet-id" {
#   value = module.mysubnet.subnet.id
# }
