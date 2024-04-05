# Define the AWS provider
provider "aws" {
  region = "us-west-2"  # Update with your desired AWS region
}

# Define VPC configuration
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  # Add VPC configuration parameters as needed
}

# Define EKS cluster configuration
module "eks_cluster_dev" {
  source                  = "terraform-aws-modules/eks/aws"
  cluster_name            = "eks-cluster-dev"
  cluster_version         = "1.21"
  vpc_id                  = module.vpc.vpc_id
  subnets                 = module.vpc.private_subnets
  node_group_name         = "ng-dev"
  node_group_instance_type = "t3.medium"
  node_group_desired_capacity = 2
  # Add other node group configurations as needed
}

# Define namespace creation within the EKS cluster
resource "kubectl_namespace" "data_pg_dev" {
  metadata {
    name = "data-pg"
  }
  depends_on = [module.eks_cluster_dev]
}

# Define EKS cluster configuration for testing and production
# Repeat the module block for each environment (testing and production), adjusting parameters as needed

# Output the kubeconfig for each EKS cluster
output "kubeconfig_dev" {
  value = module.eks_cluster_dev.kubeconfig
}

# Output other necessary information for each environment as needed
