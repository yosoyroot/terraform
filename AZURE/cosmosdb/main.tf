provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "cosmosdb" {
  name     = "cosmosdb-resource-group"
  location = "eastus"
}
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "my-cosmosdb-account"
  location            = azurerm_resource_group.cosmosdb.location
  resource_group_name = azurerm_resource_group.cosmosdb.name
  offer_type = "Standard"
  kind       = "GlobalDocumentDB"
  consistency_policy {
    consistency_level = "Session"
  }
}
output "cosmosdb_endpoint" {
  value = azurerm_cosmosdb_account.cosmosdb.document_endpoint
}
output "cosmosdb_key" {
  value = azurerm_cosmosdb_account.cosmosdb.primary_master_key
}