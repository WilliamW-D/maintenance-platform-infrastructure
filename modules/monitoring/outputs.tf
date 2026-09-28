output "workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}
output "instrumentation_key" {
  value = azurerm_application_insights.main.instrumentation_key
  sensitive = true
}
