terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.52.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "ap-south-1"
  #   access_key = "my-access-key"
  #   secret_key = "my-secret-key"
}

data "template_file" "user_data" {
  template = file("./user-creation.yaml")
}

resource "aws_key_pair" "sshkey" {
  public_key = file("./ec2sshkey.pub")
}
data "aws_security_group" "launchwizard1" {
  id = "sg-0a9adc7bd77dd9460"
}
resource "aws_instance" "tf1server" {
  ami           = "ami-067aaeea6813afbde" # ap-south-1
  instance_type = "t2.micro"
  key_name = aws_key_pair.sshkey.id
  vpc_security_group_ids = [data.aws_security_group.launchwizard1.id]
  user_data	=  data.template_file.user_data.rendered

  tags = {
    Name = "tf-example"
  }
}

output "ipaddress" {
  value = aws_instance.tf1server.public_ip

}

output "subnet" {
  value = aws_instance.tf1server.subnet_id
}


output "sgroup" {
  value = aws_instance.tf1server.security_groups
}

