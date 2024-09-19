resource "aws_vpc" "my_vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "my_vpc"
  }
}
resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_gw"
  }
}

resource "aws_route_table" "my_public_route_t" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gw.id
  }
  tags = {
    Name = "my_public_route"
  }
}
resource "aws_subnet" "my_public" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "192.168.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"
  tags = {
    Name = "public_subnet"
  }
}
resource "aws_subnet" "my_private" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "private_subnet"
  }
}
resource "aws_subnet" "my_private2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "192.168.11.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "private_subnet2"
  }
}
resource "aws_route_table_association" "my_a" {
  subnet_id        = aws_subnet.my_public.id
  route_table_id = aws_route_table.my_public_route_t.id
}

#LB
resource "aws_lb" "my_elb" {
  name               = "my-loadbalancer"
  load_balancer_type = "application"
  internal = false
  subnets = [aws_subnet.my_private.id, aws_subnet.my_private2.id]
  security_groups = [aws_security_group.sg_lb.id]
  tags = {
    Name = "myWebApp-elb"
  }
}
resource "aws_lb_target_group" "my_alb_tg" {
  name     = "my-alb-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.my_vpc.id
    health_check {
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb_listener" "my_lb_listener" {
  load_balancer_arn = aws_lb.my_elb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_alb_tg.arn
  }
}

# NAT
resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.my_gw]
  domain = "vpc"
  tags = {
    Name = "my-eip-nat"
  }
}
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id         = aws_subnet.my_public.id
}
resource "aws_route_table" "my_nat_route_t" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }
  tags = {
    Name = "my_nat_route"
  }
}
resource "aws_route_table_association" "my_nat_a" {
  subnet_id        = aws_subnet.my_private.id
  route_table_id = aws_route_table.my_nat_route_t.id
}
resource "aws_route_table_association" "my_nat_a2" {
  subnet_id        = aws_subnet.my_private2.id
  route_table_id = aws_route_table.my_nat_route_t.id
}