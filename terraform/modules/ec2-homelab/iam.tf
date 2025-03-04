# Data sources for Secrets Manager
data "aws_secretsmanager_secret" "tailscale_auth_key" {
  name = var.secrets_manager_tailscale_auth_key_name
}

data "aws_secretsmanager_secret_version" "tailscale_auth_key" {
  secret_id = data.aws_secretsmanager_secret.tailscale_auth_key.id
}

# IAM role for the instance
resource "aws_iam_role" "instance_role" {
  name = "${var.instance_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

# Policy for Secrets Manager access
resource "aws_iam_policy" "secrets_access" {
  name = "${var.instance_name}-secrets-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "secretsmanager:GetSecretValue",
      ]
      Effect = "Allow"
      Resource = [
        data.aws_secretsmanager_secret.tailscale_auth_key.arn
      ]
    }]
  })
}

# Attach AWS managed policy for SSM
resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach secrets policy to role
resource "aws_iam_role_policy_attachment" "secret_policy_attach" {
  role       = aws_iam_role.instance_role.name
  policy_arn = aws_iam_policy.secrets_access.arn
}

# Create instance profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.instance_name}-profile"
  role = aws_iam_role.instance_role.name
}
