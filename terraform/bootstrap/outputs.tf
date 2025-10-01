output "state_bucket" {
  value       = aws_s3_bucket.tf_state.bucket
  description = "S3 bucket for Terraform remote state"
}

output "lock_table" {
  value       = aws_dynamodb_table.tf_lock.name
  description = "DynamoDB table for state locking"
}

# output "github_oidc_provider_arn" {
#   value       = aws_iam_openid_connect_provider.github.arn
#   description = "OIDC provider ARN for GitHub"
# }

# output "github_actions_role_arn" {
#   value       = aws_iam_role.gha_oidc_role.arn
#   description = "IAM role ARN for GitHub Actions"
# }

output "backend_hcl_example" {
  value       = <<EOT
bucket         = "${aws_s3_bucket.tf_state.bucket}"
key            = "envs/dev/terraform.tfstate"   # change per stack/env
region         = "${var.aws_region}"
dynamodb_table = "${aws_dynamodb_table.tf_lock.name}"
encrypt        = true
EOT
  description = "Copy into backend.hcl for other Terraform stacks"
}
