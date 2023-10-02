

#add password to key Vault Secret
resource "azurerm_key_vault_secret" "sqladminpassword" {   
  name         = "sqladminpass"
  value        = var.sqlserver_admin_pass
  key_vault_id = azurerm_key_vault.fg-keyvault.id
  content_type = "text/plain"
  depends_on = [
    azurerm_key_vault.fg-keyvault,azurerm_key_vault_access_policy.kv_access_policy_01
  ]
}

resource "azurerm_key_vault_secret" "sqladminname" {   
  name         = "sqladminname"
  value        = var.sqlserver_admin
  key_vault_id = azurerm_key_vault.fg-keyvault.id
  content_type = "text/plain"
  depends_on = [
    azurerm_key_vault.fg-keyvault,azurerm_key_vault_access_policy.kv_access_policy_01
  ]
}

#Addind Sql server appServer
resource "azurerm_mssql_server" "azuresql" {
  name                         = var.sqlserver_name
  resource_group_name          = azurerm_resource_group.resourcegroupname.name
  location                     = azurerm_resource_group.resourcegroupname.location
  version                      = "12.0"
  administrator_login          = var.sqlserver_admin
  administrator_login_password = var.sqlserver_admin_pass
}

#creatind database appdb
resource "azurerm_mssql_database" "app-database" {
  name           = var.sqlserver_bd_name
  server_id      = azurerm_mssql_server.azuresql.id  
  max_size_gb    = 2
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false

  tags = {
    Application = "ApiDb"    
  }
}

#allow subnet from the api vnet to db
resource "azurerm_mssql_virtual_network_rule" "allow-api" {
  name      = "api-sql-vnet-rule"
  server_id = azurerm_mssql_server.azuresql.id
  subnet_id = azurerm_subnet.api-subnet.id
  depends_on = [
    azurerm_mssql_server.azuresql
  ]
}