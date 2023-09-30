variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

# variable "resource_group_name_prefix" {
#   type        = string
#   default     = "rg"
#   description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
# }

# get the details from KODEKLOUD after login 'az group list -o yaml'
variable "resource_group_name" {
  type        = string
  default     = "ODL-azure-1058009"
  description = "RG name provided by KODEKLOUD"
}