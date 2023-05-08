# Roles for what?
# Fargate task execution? There are defaults, why not modify those?

data "aws_iam_policy_document" "ecs_exec_group" {
  statement {
    
  }
}

module "iam_group_with_policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"

  name = "superadmins"

  group_users = [
    "toel",
    "terraform"
  ]

  attach_iam_self_management_policy = true

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]

  custom_group_policies = [
    {
      name   = "AllowS3Listing"
      policy = data.aws_iam_policy_document.ecs_exec_group.json
    }
  ]
}

# module "iam_assumable_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

#   trusted_role_arns = [
#     "arn:aws:iam::307990089504:root",
#     "arn:aws:iam::835367859851:user/anton",
#   ]

#   create_role = true

#   role_name         = "custom"
#   role_requires_mfa = true

#   custom_role_policy_arns = [
#     "arn:aws:iam::aws:policy/AmazonCognitoReadOnly",
#     "arn:aws:iam::aws:policy/AlexaForBusinessFullAccess",
#   ]
#   number_of_custom_role_policy_arns = 2
# }

# module "iam_assumable_roles" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"

#   trusted_role_arns = [
#     "arn:aws:iam::307990089504:root",
#     "arn:aws:iam::835367859851:user/anton",
#   ]

#   create_admin_role = true

#   create_poweruser_role = true
#   poweruser_role_name   = "developer"

#   create_readonly_role       = true
#   readonly_role_requires_mfa = false
# }

# module "iam_eks_role" {
#   source      = "terraform-aws-modules/iam/aws//modules/iam-eks-role"

#   role_name   = "my-app"

#   cluster_service_accounts = {
#     "cluster1" = ["default:my-app"]
#     "cluster2" = [
#       "default:my-app",
#       "canary:my-app",
#     ]
#   }

#   tags = {
#     Name = "eks-role"
#   }

#   role_policy_arns = {
#     AmazonEKS_CNI_Policy = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   }
# }

