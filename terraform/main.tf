data "azurerm_client_config" "current" {}

# Main Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# Monitoring Module (Log Analytics + App Insights)
module "monitoring" {
  source              = "../modules/monitoring"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project_name        = var.project_name
}

# Key Vault Module
module "key_vault" {
  source              = "../modules/key-vault"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project_name        = var.project_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  
  database_password   = var.database_admin_password
  jwt_secret          = var.jwt_secret
}

# Container Registry Module
module "registry" {
  source              = "../modules/registry"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project_name        = var.project_name
}

# PostgreSQL Database Module
module "database" {
  source              = "../modules/database"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project_name        = var.project_name
  admin_login         = var.database_admin_login
  admin_password      = var.database_admin_password
}

# Container Apps Module (FastAPI & React)
module "container_app" {
  source              = "../modules/container-app"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project_name        = var.project_name
  
  log_analytics_id    = module.monitoring.workspace_id
  registry_login_server = module.registry.login_server
  registry_username   = module.registry.admin_username
  registry_password   = module.registry.admin_password
  
  key_vault_uri       = module.key_vault.vault_uri
  db_connection_string = module.database.connection_string
}
