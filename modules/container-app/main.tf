variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "environment" { type = string }
variable "project_name" { type = string }

variable "log_analytics_id" { type = string }
variable "registry_login_server" { type = string }
variable "registry_username" { type = string }
variable "registry_password" { type = string }
variable "key_vault_uri" { type = string }
variable "db_connection_string" { type = string }

resource "azurerm_container_app_environment" "main" {
  name                       = "cae-${var.project_name}-${var.environment}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_id
}

resource "azurerm_container_app" "backend" {
  name                         = "ca-api-${var.project_name}-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  registry {
    server               = var.registry_login_server
    username             = var.registry_username
    password_secret_name = "registry-password"
  }

  secret {
    name  = "registry-password"
    value = var.registry_password
  }

  secret {
    name  = "db-connection"
    value = var.db_connection_string
  }

  template {
    container {
      name   = "api"
      image  = "${var.registry_login_server}/work-order-api:latest"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name        = "DATABASE_URL"
        secret_name = "db-connection"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8000
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

resource "azurerm_container_app" "frontend" {
  name                         = "ca-web-${var.project_name}-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  registry {
    server               = var.registry_login_server
    username             = var.registry_username
    password_secret_name = "registry-password"
  }

  secret {
    name  = "registry-password"
    value = var.registry_password
  }

  template {
    container {
      name   = "web"
      image  = "${var.registry_login_server}/maintenance-ops-dashboard:latest"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "VITE_API_URL"
        value = "https://${azurerm_container_app.backend.latest_revision_fqdn}"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}
