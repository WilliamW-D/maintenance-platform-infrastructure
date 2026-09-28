output "connection_string" {
  value = "postgresql://${var.admin_login}:${var.admin_password}@${azurerm_postgresql_flexible_server.main.fqdn}:5432/${azurerm_postgresql_flexible_server_database.work_orders.name}?sslmode=require"
  sensitive = true
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}
