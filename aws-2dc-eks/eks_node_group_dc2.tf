


resource "aws_eks_node_group" "dc2_node_group" {
  provider        = aws.dc2
  cluster_name    = aws_eks_cluster.dc2_eks.name
  node_group_name = "${var.name}-dc2-eks-node-grp"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = values(aws_subnet.dc2-private)[*].id

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 0
  }

  launch_template {
    id      = aws_launch_template.dc2_eks_instance.id
    version = "$Latest"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_eks_cluster.dc2_eks,
    aws_launch_template.dc2_eks_instance,
    aws_iam_role.eks_node_role,
  ]
}
