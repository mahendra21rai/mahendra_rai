
resource "azurerm_service_plan" "api-sp" {
  name                = "api-sp"
  resource_group_name = azurerm_resource_group.resourcegroupname.name
  location            = azurerm_resource_group.resourcegroupname.location
  os_type             = "Linux"
  sku_name            = "B1"
  depends_on = [
    azurerm_subnet.api-subnet
  ]
}

resource "azurerm_linux_function_app" "api-fnapp" {
  name                = "init-api-function-app"
  resource_group_name = azurerm_resource_group.resourcegroupname.name
  location            = azurerm_resource_group.resourcegroupname.location

  storage_account_name       = azurerm_storage_account.app-storageaccount.name
  storage_account_access_key = azurerm_storage_account.app-storageaccount.primary_access_key
  service_plan_id            = azurerm_service_plan.api-sp.id
  

  app_settings = {

    "APPINSIGHTS_INSTRUMENTATIONKEY"  = azurerm_application_insights.app-insights.instrumentation_key
  }

  site_config {

  ip_restriction {
          virtual_network_subnet_id = azurerm_subnet.app-subnet.id
          priority = 100
          name = "Frontend app access only"
           }
  }

  identity {
  type = "SystemAssigned"
   }

 depends_on = [
   azurerm_storage_account.app-storageaccount
 ]
}

#Backend
#storage account for functionapp
resource "azurerm_storage_account" "app-storageaccount" {
  name                     = "functionappsamahendrarai"
  resource_group_name      = azurerm_resource_group.resourcegroupname.name
  location                 = azurerm_resource_group.resourcegroupname.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}