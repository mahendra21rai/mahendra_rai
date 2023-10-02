#data "azurerm_client_config" "current" {}



resource "azurerm_key_vault" "fg-keyvault" {
  name                        = "appkeyvault"
  location                    = azurerm_resource_group.resourcegroupname.location
  resource_group_name         = azurerm_resource_group.resourcegroupname.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id  
  sku_name                    = "standard"
}

resource "azurerm_key_vault_access_policy" "kv_access_policy_01" {
  key_vault_id       = azurerm_key_vault.fg-keyvault.id
  tenant_id          = var.tenant_id
  object_id          = var.client_id
  key_permissions    = ["Get", "List"]
  secret_permissions = ["Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set"]

  depends_on = [azurerm_key_vault.fg-keyvault]
}
