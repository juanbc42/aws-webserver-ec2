
data "aws_secretsmanager_secret" "deploy_key" {
  name = "github-deploy-key"
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-github-clone-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "sm_read" {
  name = "secrets-manager-read-github-deploy-key"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid : "AllowReadSecret",
      Effect : "Allow",
      Action : ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"],
      Resource : data.aws_secretsmanager_secret.deploy_key.arn }
  ] })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.sm_read.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-github-clone-profile"
  role = aws_iam_role.ec2_role.name
}

