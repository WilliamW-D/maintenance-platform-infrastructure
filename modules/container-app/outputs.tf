output "frontend_url" {
  value = "https://${azurerm_container_app.frontend.latest_revision_fqdn}"
}

output "backend_api_url" {
  value = "https://${azurerm_container_app.backend.latest_revision_fqdn}"
}
