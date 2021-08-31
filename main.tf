resource "aws_vpc" "myapp-vpc" {
    cidr_block = "10.0.0.0/18"
    tags = {
      Name = "devops-vpc"
    }

  
}
resource "aws_subnet" "myapp-subnet" {
    vpc_id     = aws_vpc.myapp-vpc.id 
    cidr_block = "10.0.0.0/19"
    availability_zone = "us-east-1a"

    tags = {
      Name = "devops_subnet1"
  }
  
}

resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.myapp-igw.id   

  }

  tags = {
      Name: "devops-rtb"
      }
}

resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id
    tags =  {
        Name: "devops-igw"
    }
} 

resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = aws_subnet.myapp-subnet.id  
    route_table_id = aws_route_table.myapp-route-table.id  

}

resource "aws_security_group" "devops14_2021" {
  name        = "devops_sg"
  description = "dynamic-sg"
  vpc_id      = aws_vpc.myapp-vpc.id
  dynamic "ingress" {
      for_each = var.ingress_ports
      content {
          from_port = ingress.value
          to_port = ingress.value
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
      } 
  }
  dynamic "egress" {
      for_each = var.egress_ports
      content {
          from_port = egress.value
          to_port = egress.value
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
      } 
  }

  
  
  tags = {
    Name = "devops-dynamic-sg"
  }
}

resource "aws_instance" "devops-ec2" {
  ami           = lookup(var.ami, "us-east-1")
  instance_type = var.instance_type[0]
  subnet_id = aws_subnet.myapp-subnet.id
  vpc_security_group_ids = [aws_security_group.devops14_2021.id] 
  key_name      = aws_key_pair.my-key.key_name
  #count         = 3
  tags = {
    "Name" = element(var.tags, 0)
  }
}

resource "aws_key_pair" "my-key" {
  key_name   = "devops14_2021"
  public_key = file(var.public_key_location)
}

resource "aws_eip" "my_eip" {
  instance = aws_instance.devops-ec2.id   
  vpc = true
  tags = {
    Name  = "devops14_2021"
    Owner = "David"

  }
}

output "ec2_elastic-ip" {
    value = aws_eip.my_eip.public_ip
}
