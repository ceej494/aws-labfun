# resource "aws_key_pair" "my_key_pair" {
#   key_name   = "my_key_pair"
#   public_key = file("~/Documents/CJ/LabFun/my-key.pub")
# }

resource "aws_instance" "mongo_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ssh_access.id, aws_security_group.only_my_vpc.id]
  subnet_id     = aws_subnet.my_public.id
  iam_instance_profile = aws_iam_instance_profile.mongo_admin_profile.name
  key_name = "mongo-key-pair"
  tags = {
    Name = var.instance_name
  }
}

