variable "target_env" {
  description = "Target environment for deployment: 'aws' or 'local'"
  type        = string
  default     = "local"
}

variable "argocd_version" {
  type = string
}

variable "github_token" {
  description = "GitHub token for ArgoCD to access private repositories"
  type        = string
  sensitive   = true
}

variable "github_repository" {
  description = "GitHub repository in format owner/repo"
  type        = string
}
