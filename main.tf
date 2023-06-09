variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}


terraform {
   required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "3.59.0"
      }  
   }
}

#az ad sp create-for-rbac --name azure-cli-fabio --role="Contributor" --scopes "/subscriptions/393e3de3-0900-4b72-8f1b-fb3b1d6b97f1"

provider "azurerm" {
   subscription_id = "393e3de3-0900-4b72-8f1b-fb3b1d6b97f1"
   client_id = "2ac719ef-3f8b-45ad-b133-8d66e0919476"
   client_secret = "9rf8Q~iPU1Ur5fvNpXk.Z1kl99-27F16mygVNcLG"
   tenant_id = "7349d3b2-951f-41be-877e-d8ccd9f3e73c"
   skip_provider_registration = true
   features {}
}

resource "azurerm_resource_group" "webserver" {
   name = "server-fabio"
   location = "westeurope"
}


resource "azurerm_network_interface_security_group_association" "nsgnic" {
  network_interface_id      = azurerm_network_interface.webserver.id
  network_security_group_id = azurerm_network_security_group.allowedports.id
}

resource "azurerm_network_security_group" "allowedports" {
   name = "allowedports"
   resource_group_name = azurerm_resource_group.webserver.name
   location = azurerm_resource_group.webserver.location
  
   security_rule {
       name = "http"
       priority = 100
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "80"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }

   security_rule {
       name = "https"
       priority = 200
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "443"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }

    security_rule {
       name = "custom"
       priority = 400
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "8080"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }
   
   security_rule {
       name = "ssh"
       priority = 300
       direction = "Inbound"
       access = "Allow"
       protocol = "Tcp"
       source_port_range = "*"
       destination_port_range = "22"
       source_address_prefix = "*"
       destination_address_prefix = "*"
   }
}

resource "azurerm_public_ip" "webserver_public_ip" {
   name = "webserver_public_ip"
   location = "westeurope"
   resource_group_name = azurerm_resource_group.webserver.name
   allocation_method = "Dynamic"

   depends_on = [azurerm_resource_group.webserver]
}

resource "azurerm_network_interface" "webserver" {
   name = "interface"
   location = azurerm_resource_group.webserver.location
   resource_group_name = azurerm_resource_group.webserver.name

   ip_configuration {
       name = "internal"
       private_ip_address_allocation = "Dynamic"
       subnet_id = azurerm_subnet.webserver-subnet.id
       public_ip_address_id = azurerm_public_ip.webserver_public_ip.id
   }

   depends_on = [azurerm_resource_group.webserver]
}

resource "azurerm_linux_virtual_machine" "nginx" {
   size = "Standard_D4s_v3"
   name = "webserver"
   resource_group_name = azurerm_resource_group.webserver.name
   location = azurerm_resource_group.webserver.location
   network_interface_ids = [
       azurerm_network_interface.webserver.id,
   ]

   source_image_reference {
       publisher = "Canonical"
       offer = "UbuntuServer"
       sku = "18.04-LTS"
       version = "latest"
   }

   computer_name = "nginx"
   admin_username = "fabio"
   admin_password = "Azerty-123"
   disable_password_authentication = false

   os_disk {
       name = "nginxdisk01"
       caching = "ReadWrite"
       #create_option = "FromImage"
       storage_account_type = "Standard_LRS"
   }


   depends_on = [azurerm_resource_group.webserver]
}

resource "azurerm_virtual_network" "webserver-net" {
  name                = "webserver-net"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.webserver.location
  resource_group_name = azurerm_resource_group.webserver.name
}

resource "azurerm_subnet" "webserver-subnet" {
  name                 = "subnet01"
  resource_group_name  = azurerm_resource_group.webserver.name
  virtual_network_name = azurerm_virtual_network.webserver-net.name
  address_prefixes       = ["10.0.1.0/24"]

  private_link_service_network_policies_enabled = false
}
