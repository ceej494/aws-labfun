output "security_group_id" {
  value = aws_security_group.ssh_access.id
}
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
output "public_subnet_id" {
  value = aws_subnet.my_public.id
}
output "private_subnet_id" {
  value = aws_subnet.my_private.id
}
output "instance_name" {
    value = aws_instance.mongo_server.tags.Name
}
output "iam_instance_profile" {
    value = aws_iam_instance_profile.mongo_admin_profile.name
}
output "iam_admin_role" {
    value = aws_iam_role.mongo_admin_role.name
}
output "iam_ec2_mongo_policy" {
    value = aws_iam_role_policy.ec2_mongo_policy.name
}
output "alb_dns_name" {
  value = aws_lb.my_elb.dns_name
}
output "aws_eks_cluster" {
  value = aws_eks_cluster.my_cluster.name
}
