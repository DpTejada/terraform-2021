ingress_ports = [22, 80, 443]
egress_ports = [8000, 8080, 8888]
ami = {
    us-east-1 = "ami-0c2b8ca1dad447f8a"
    us-east-2 = "ami-0443305dabd4be2bc"
    us-west-1 = "ami-04b6c97b14c54de18"
    us-west-2 = "ami-083ac7c7ecf9bb9b0"
}
tags = ["my-first-ec2", "my-second-ec2", "my-third-ec2"]
public_key_location = "/root/.ssh/id_rsa.pub"
instance_type = ["t2.micro", "t2.nano", "t2.small"]
