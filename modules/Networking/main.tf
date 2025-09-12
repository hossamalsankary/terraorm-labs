
locals {
    project = "route_project"
    route_table_cidrs = "0.0.0.0/0"
}

resource "aws_vpc" "route_project" {
  cidr_block           = var.vpc_cider

  tags = {
    Name = "${local.project}-${var.vpc_cider}"
  }
}

resource "aws_internet_gateway" "hossam_igw" {
  vpc_id = aws_vpc.route_project.id

  tags = {
    Name = "${local.project}-igw"
  }
  
}

# us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1e, us-east-1f

resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id                  = aws_vpc.route_project.id
  cidr_block              = var.subnets_cirder[count.index]
  availability_zone       = var.availability_zone[count.index]


  tags = {
    Name = "${local.project}-public_subnet_${count.index + 1}"
  }
}

# create route table
resource "aws_route_table" "public_subnet" {
  count = 2
  vpc_id = aws_vpc.route_project.id

  route {
    cidr_block = local.route_table_cidrs
    gateway_id = aws_internet_gateway.hossam_igw.id
  }
}

# associate with public subnets
resource "aws_route_table_association" "public_subnet" {
  count = 2
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_subnet[count.index].id
}




resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id                  = aws_vpc.route_project.id
  cidr_block              = var.subnets_cirder[count.index + 2]
  availability_zone       = var.availability_zone[count.index + 2]

  tags = {
    Name = "${local.project}-private_subnet_${count.index + 2}"
  }
}



# # create nat gateway
resource "aws_eip" "nat_eip" {
  count = 2
  tags = {
    Name = "${local.project}-nat_eip-${count.index }"
  }
}


resource "aws_nat_gateway" "public_nat_gateway" {
  count = 2
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id    = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "${local.project}-public_nat_gateway_${count.index }"
  }
}

# create route table for private subnets
resource "aws_route_table" "private_subnet" {
  count = 2
  vpc_id = aws_vpc.route_project.id

  route {
    cidr_block = local.route_table_cidrs
    nat_gateway_id = aws_nat_gateway.public_nat_gateway[count.index].id
  }
}
# # associate with private subnets
resource "aws_route_table_association" "private_subnet" {
  count = 2
  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_subnet[count.index].id
}

resource "aws_security_group" "security_group" {
  name        = "allow_web traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.route_project.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}
