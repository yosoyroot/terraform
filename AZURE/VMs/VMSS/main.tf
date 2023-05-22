provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "eastus"
}
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
resource "azurerm_subnet" "example" {
  name           = "example-subnet"
  address_prefix = "10.0.1.0/24"
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.example.name
}
resource "azurerm_lb" "example" {
  name                = "example-lb"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  frontend_ip_configuration {
    name                          = "example-lb-feip"
    public_ip_address_id          = azurerm_public_ip.example.id
    private_ip_address_allocation = "Dynamic"
  }
  backend_address_pool {
    name = "example-lb-bepool"
  }
}
resource "azurerm_public_ip" "example" {
  name                = "example-pip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_configuration {
    name                          = "example-nic-ipconfig"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}
resource "azurerm_virtual_machine_scale_set" "example" {
  name                = "example-vmss"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard_DS1_v2"
  upgrade_policy_mode = "Manual"
  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  os_profile {
    computer_name_prefix = "example-vmss"
    admin_username       = "adminuser"
    admin_password       = "Password1234!"
  }
  network_profile {
    name    = "example-vmss-np"
    primary = true
    network_interface {
      id = azurerm_network_interface.example.id
    }
  }
  rolling_upgrade_policy {
    max_batch_instance_percent           = 20
    max_unhealthy_instance_percent       = 20
    pause_time_between_batches           = "PT30S"
    wait_time_between_rollback_attempts = "PT30S"
  }
  capacity {
    default = 2
    minimum = 1
    maximum = 5
  }
}