variable "target_env" {
  description = "Target environment for deployment: 'aws' or 'local'"
  type        = string
  default     = "local"
}

variable "argocd_version" {
  type = string
}
