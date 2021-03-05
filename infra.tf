provider "aws" {
  region     = "ap-south-1"
  access_key = "replace with access key"
  secret_key = "replace with secret key"
}

resource "aws_vpc" "vpc-ajay" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    instance_tenancy = "default"
}

resource "aws_subnet" "subnet-public" {
    vpc_id = aws_vpc.vpc-ajay.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
}

resource "aws_internet_gateway" "first-igw" {
    vpc_id = aws_vpc.vpc-ajay.id
}

resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.vpc-ajay.id
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = aws_internet_gateway.first-igw.id 
    }
}

resource "aws_route_table_association" "public-rt-public-subnet"{
    subnet_id = aws_subnet.subnet-public.id
    route_table_id = aws_route_table.public-rt.id
}

resource "aws_security_group" "my-sg" {
    vpc_id = aws_vpc.vpc-ajay.id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

        ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "web3" {
    ami = "ami-08e0ca9924195beba"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet-public.id
    vpc_security_group_ids = [ aws_security_group.my-sg.id ]
    key_name = "newkey"
    user_data = <<-EOF
                 #!/bin/bash
                 sudo amazon-linux-extras install docker -y
                 sudo service docker start
                 sudo usermod -a -G docker root
                 sudo yum install git -y
                 EOF
    
}
