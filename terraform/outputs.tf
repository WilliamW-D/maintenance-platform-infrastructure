output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "acr_login_server" {
  value = module.registry.login_server
}

output "frontend_url" {
  value = module.container_app.frontend_url
}

output "backend_api_url" {
  value = module.container_app.backend_api_url
}
