terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.40.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "blc" {
  name     = "blc-resources"
  location = "North Europe"
}

resource "azurerm_virtual_network" "blcnet" {
  name                = "blc-network"
  address_space       = ["10.5.0.0/16"]
  location            = azurerm_resource_group.blc.location
  resource_group_name = azurerm_resource_group.blc.name
}

resource "azurerm_subnet" "blc" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.blc.name
  virtual_network_name = azurerm_virtual_network.blcnet.name
  address_prefixes     = ["10.5.2.0/24"]
}

resource "azurerm_network_interface" "blc" {
  name                = "blc-nic"
  location            = azurerm_resource_group.blc.location
  resource_group_name = azurerm_resource_group.blc.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.blc.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
  depends_on = [azurerm_resource_group.blc]
}

resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.blc.location
  resource_group_name = azurerm_resource_group.blc.name
  allocation_method   = "Dynamic"
}

resource "azurerm_linux_virtual_machine" "blc" {
  name                = "blc-machine"
  resource_group_name = azurerm_resource_group.blc.name
  location            = azurerm_resource_group.blc.location
  size                = "Standard_B2s"
  admin_username      = "ubuntu"
  custom_data         = base64encode(file("user_data.sh"))
  network_interface_ids = [
    azurerm_network_interface.blc.id,
  ]
  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  depends_on = [azurerm_resource_group.blc]
}
resource "azurerm_network_security_group" "blc-SG" {
  name                = "allowedports"
  resource_group_name = azurerm_resource_group.blc.name
  location            = azurerm_resource_group.blc.location

  security_rule {
    name                       = "http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ssh"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.blc.public_ip_address
}

