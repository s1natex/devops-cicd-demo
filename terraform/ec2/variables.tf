variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Existing EC2 key pair name"
}

variable "allowed_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "volume_size_gb" {
  type    = number
  default = 8
}

variable "project" {
  type    = string
  default = "my-devops-cicd-demo"
}

variable "image_repo" {
  type    = string
  default = "s1natex/my-devops-cicd-demo"
}

variable "api_tag" {
  type    = string
  default = "api-latest"
}

variable "web_tag" {
  type    = string
  default = "web-latest"
}

variable "encrypt_ebs" {
  type    = bool
  default = true
}

variable "kms_key_id" {
  description = "KMS key for EBS encryption (null = AWS managed key aws/ebs)"
  type        = string
  default     = null
}

variable "root_volume_size_gb" {
  type    = number
  default = 8
}
