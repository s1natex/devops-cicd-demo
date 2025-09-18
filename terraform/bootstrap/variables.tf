variable "project" {
  description = "Short project used in names"
  type        = string
  default     = "my-devops-cicd-demo"
}

variable "aws_region" {
  description = "AWS region to create bootstrap resources"
  type        = string
  default     = "eu-north-1"
}

variable "github_owner" {
  description = "GitHub user that owns the repo"
  type        = string
  default     = "s1natex"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "my-devops-cicd-demo"
}

variable "allowed_branches" {
  description = "Branches allowed to assume the OIDC role"
  type        = list(string)
  default     = ["main", "dev"]
}

variable "role_policy_arn" {
  description = "AWS managed policy to attach to the GitHub Actions role"
  type        = string
  default     = "arn:aws:iam::aws:policy/PowerUserAccess"
}
