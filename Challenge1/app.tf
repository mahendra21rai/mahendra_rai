resource "azurerm_service_plan" "app-sp" {
  name                = "app-sp"
  resource_group_name = azurerm_resource_group.resourcegroupname.name
  location            = azurerm_resource_group.resourcegroupname.location
  os_type             = "Linux"
  sku_name            = "B1"
  depends_on = [
    azurerm_subnet.app-subnet
  ]
}

#Frontend
# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = "frontend-app-int"
  location              = azurerm_resource_group.resourcegroupname.location
  resource_group_name   = azurerm_resource_group.resourcegroupname.name
  service_plan_id       = azurerm_service_plan.app-sp.id
  https_only            = true
  site_config { 
    minimum_tls_version = "1.2"
    always_on = true
  }
  
  app_settings = {

    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.app-insights.instrumentation_key
   
  }

  
  depends_on = [
    azurerm_service_plan.app-sp,azurerm_application_insights.app-insights
  ]
}