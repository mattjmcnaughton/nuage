# AWS GPU Instance Module

This Terraform module provisions an EC2 instance (optimized for GPU workloads) with Tailscale and SSM connectivity, monitoring, and cost control.

## Features

- Launches an EC2 instance with optional GPU support
- Configures Tailscale for secure remote access
- Sets up AWS Systems Manager for backup access
- Creates security groups with minimal permissions
- Sets up cost and runtime alarms
- Configures IAM permissions for instance services

## Usage

```hcl
module "gpu_instance" {
  source = "./ec2-homelab"

  vpc_id       = "vpc-0123456789abcdef0"
  alert_email  = "your-email@example.com"

  # Optional parameters
  instance_type     = "g4dn.xlarge"
  instance_name     = "my-gpu-instance"
  username          = "adminuser"
  max_budget        = 30             # $30 per month
  max_runtime_hours = 6              # 6 hours
  is_gpu_instance   = true           # Install GPU drivers and tools

  data_volume_size = 30

  tags = {
    Environment = "Development"
    Project     = "ML Research"
  }
}
```
