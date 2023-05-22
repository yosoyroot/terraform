variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

# get the details from KODEKLOUD after login 'az group list -o yaml'
variable "resource_group_name" {
  type        = string
  default     = "ODL-azure-953511"
  description = "RG name provided by KODEKLOUD"
}

variable "prefix" {
  type        = string
  default     = "win-vm-iis"
  description = "Prefix of the resource name"
}