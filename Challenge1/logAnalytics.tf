resource "azurerm_log_analytics_workspace" "app-loganalytics" {
  name                = "app-loganalytics-workspace"
  location            = azurerm_resource_group.resourcegroupname.location
  resource_group_name = azurerm_resource_group.resourcegroupname.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "app-insights" {
  name                = "app-insights"
  location            = azurerm_resource_group.resourcegroupname.location
  resource_group_name = azurerm_resource_group.resourcegroupname.name
  workspace_id        = azurerm_log_analytics_workspace.app-loganalytics.id
  application_type    = "web"
  depends_on = [
    azurerm_log_analytics_workspace.app-loganalytics
  ]
}

output "instrumentation_key" {
  value = azurerm_application_insights.app-insights.instrumentation_key
  sensitive = true
}

output "app_id" {
  value = azurerm_application_insights.app-insights.id
  sensitive = true
}