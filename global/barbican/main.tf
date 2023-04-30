module "ec2_spot_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws//examples/complete"
  version = "5.0.0"

  name                 = "${local.name}-spot-instance"
  create_spot_instance = true

  availability_zone           = element(module.vpc.azs, 0)
  subnet_id                   = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true

  # Spot request specific attributes
  spot_price                          = "0.1"
  spot_wait_for_fulfillment           = true
  spot_type                           = "persistent"
  spot_instance_interruption_behavior = "terminate"
  # End spot request specific attributes

  user_data_base64 = base64encode(local.user_data)

  cpu_core_count       = 2 # default 4
  cpu_threads_per_core = 1 # default 2

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      tags = {
        Name = "my-root-block"
      }
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = 5
      throughput  = 200
      encrypted   = true
      # kms_key_id  = aws_kms_key.this.arn # you must grant the AWSServiceRoleForEC2Spot service-linked role access to any custom KMS keys
    }
  ]

  tags = local.tags
}
