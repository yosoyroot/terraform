provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "yosoyroot" {
  name     = "yosoyroot-rg"
  location = "eastus"
}
resource "azurerm_kubernetes_cluster" "yosoyroot" {
  name                = "yosoyroot-aks"
  location            = azurerm_resource_group.yosoyroot.location
  resource_group_name = azurerm_resource_group.yosoyroot.name
  dns_prefix          = "yosoyroot-aks"
  agent_pool_profile {
    name            = "yosoyroot-aks-pool"
    count           = 3
    vm_size         = "Standard_D2_v2"
    os_type         = "Linux"
    vnet_subnet_id  = "subnet-id"
  }
  service_principal {
    client_id     = "client-id"
    client_secret = "client-secret"
  }
  depends_on = [
    azurerm_resource_group.yosoyroot
  ]
}
resource "azurerm_public_ip" "yosoyroot" {
  name                = "yosoyroot-ip"
  location            = azurerm_resource_group.yosoyroot.location
  resource_group_name = azurerm_resource_group.yosoyroot.name
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "yosoyroot" {
  name                = "yosoyroot-nic"
  location            = azurerm_resource_group.yosoyroot.location
  resource_group_name = azurerm_resource_group.yosoyroot.name
  ip_configuration {
    name                          = "yosoyroot-ip-config"
    subnet_id                     = "subnet-id"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.yosoyroot.id
  }
}
resource "azurerm_role_assignment" "yosoyroot" {
  scope                = azurerm_kubernetes_cluster.yosoyroot.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = "principal-id"
}
resource "azurerm_kubernetes_service" "yosoyroot" {
  depends_on = [
    azurerm_kubernetes_cluster.yosoyroot,
    azurerm_role_assignment.yosoyroot
  ]
  name                = "yosoyroot-ingress"
  location            = azurerm_resource_group.yosoyroot.location
  resource_group_name = azurerm_resource_group.yosoyroot.name
  dns_name_label      = "yosoyroot-ingress"
  depends_on = [
    azurerm_kubernetes_cluster.yosoyroot,
    azurerm_role_assignment.yosoyroot
  ]
  load_balancer_profile {
    managed_outbound_ips {
      count = 1
    }
  }
}