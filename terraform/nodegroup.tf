module "eks_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.8.4"

  cluster_name    = module.eks.cluster_name
  cluster_version = module.eks.cluster_version

  name = "hello-node-group"

  subnet_ids = module.vpc.public_subnets

  instance_types = ["t3.micro"]

  min_size     = 1
  max_size     = 1
  desired_size = 1

  cluster_service_cidr = "172.20.0.0/16"
}
