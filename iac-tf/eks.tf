resource "aws_eks_cluster" "my_cluster" {
  name     = "web_app_cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = [aws_subnet.my_private.id, aws_subnet.my_private2.id]
  }
  depends_on = [
    aws_iam_role_policy_attachment.myWebApp-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.myWebApp-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "my_nodes" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "myWebApp-nodes"
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = [aws_subnet.my_private.id]

  instance_types = ["t2.small"]
  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }
  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}