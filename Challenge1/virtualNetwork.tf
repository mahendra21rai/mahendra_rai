# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "app-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resourcegroupname.location
  resource_group_name = azurerm_resource_group.resourcegroupname.name
}
#Create App frontend subnets
resource "azurerm_subnet" "app-subnet" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.resourcegroupname.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/26"]
  service_endpoints = ["Microsoft.Web"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action","Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }


  }
 
}

#Create API subnets
resource "azurerm_subnet" "api-subnet" {
  name                 = "api-subnet"
  resource_group_name  = azurerm_resource_group.resourcegroupname.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.64/26"]
  service_endpoints = ["Microsoft.Sql"]  

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action","Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }


  }
}

#vnet integration of backend app frontend
resource "azurerm_app_service_virtual_network_swift_connection" "app-vnet-integration" {
  app_service_id = azurerm_linux_web_app.webapp.id
  subnet_id      = azurerm_subnet.app-subnet.id

  depends_on = [
    azurerm_linux_web_app.webapp
  ]
}

#vnet integration of Api backend functions
resource "azurerm_app_service_virtual_network_swift_connection" "api-vnet-integration" {
  app_service_id = azurerm_linux_function_app.api-fnapp.id
  subnet_id      = azurerm_subnet.api-subnet.id
  depends_on = [
    azurerm_linux_function_app.api-fnapp
  ]
}


