variable "environment" {
  type        = string
  description = "The deployment environment (e.g., dev, prod)"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "Azure region for the resources"
  default     = "eastus"
}

variable "project_name" {
  type        = string
  description = "Base name for the project resources"
  default     = "maintops"
}

variable "database_admin_login" {
  type        = string
  description = "Administrator login for PostgreSQL"
  default     = "pgadmin"
}

variable "database_admin_password" {
  type        = string
  description = "Administrator password for PostgreSQL (should be passed securely)"
  sensitive   = true
}

variable "jwt_secret" {
  type        = string
  description = "JWT Secret for FastAPI Authentication"
  sensitive   = true
}
