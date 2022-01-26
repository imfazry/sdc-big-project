provider "aws"{
  region = "ap-southeast-1"
}
data "aws_subnet" "example" {
  id       = "subnet-07a2296ef5d5b8984"
}
resource "aws_instance" "jenkins_instance" {
  ami = "ami-055d15d9cfddf7bd3"
  instance_type = "t3.medium"
  key_name = "adam1"
  subnet_id = data.aws_subnet.example.id
  associate_public_ip_address = true
  monitoring = false
  
  provisioner "remote-exec" {
    
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install python3 -y"
    ]

    connection {
      host = self.public_ip
      user = "ubuntu"
      private_key = file("~/Downloads/adam1.pem")
      type = "ssh"
    }

   
  }

   provisioner "local-exec" {
      working_dir = "/home/fazry93/terraform/playbook1"
      command = "ansible-playbook -i ${self.public_ip}, -u ubuntu --private-key ~/Downloads/adam1.pem jenkins.yaml"
    }
}