output "ec2-public-ip" {
  value = module.myapp-webserver.instance.public_ip
}