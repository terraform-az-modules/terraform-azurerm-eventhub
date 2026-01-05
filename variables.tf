##-----------------------------------------------------------------------------
## Naming convention
##-----------------------------------------------------------------------------
variable "custom_name" {
  type        = string
  default     = null
  description = "Override default naming convention"
}

variable "resource_position_prefix" {
  type        = bool
  default     = true
  description = <<EOT
Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.

- If true, the keyword is prepended: "vnet-core-dev".
- If false, the keyword is appended: "core-dev-vnet".

This helps maintain naming consistency based on organizational preferences.
EOT
}

##-----------------------------------------------------------------------------
## Labels
##-----------------------------------------------------------------------------
variable "name" {
  type        = string
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "managedby" {
  type        = string
  default     = "terraform-az-modules"
  description = "ManagedBy, eg 'terraform-az-modules'."
}

variable "extra_tags" {
  type        = map(string)
  default     = null
  description = "Variable to pass extra tags."
}

variable "repository" {
  type        = string
  default     = "https://github.com/terraform-az-modules/terraform-azure-eventhub"
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "deployment_mode" {
  type        = string
  default     = "terraform"
  description = "Specifies how the infrastructure/resource is deployed"
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment", "location"]
  description = "The order of labels used to construct resource names or tags. If not specified, defaults to ['name', 'environment', 'location']."
}

variable "location" {
  description = "Azure location where resources should be deployed."
  type        = string
  default     = ""
}


##-----------------------------------------------------------------------------
## Global Variables
##-----------------------------------------------------------------------------
variable "enabled" {
  type        = bool
  default     = true
  description = "Flag to control the module creation"
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
  type        = string
  default     = ""
}


##------------------------------------------------------------------------------
# Resource Variables
##------------------------------------------------------------------------------
variable "sku" {
  description = "Defines which tier to use. Valid options are Basic and Standard."
  default     = "Standard"
  type        = string
}

variable "capacity" {
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace. Valid values range from 1 - 20."
  type        = number
  default     = 1
}

variable "auto_inflate" {
  description = "Is Auto Inflate enabled for the EventHub Namespace, and what is maximum throughput?"
  type = object({
    enabled                  = bool
    maximum_throughput_units = number
  })
  default = null
}

variable "network_rules" {
  description = "Network rules restricting access to the event hub."
  type = object({
    ip_rules   = list(string)
    subnet_ids = list(string)
  })
  default = null
}

variable "authorization_rules" {
  description = "Authorization rules to add to the namespace. For hub use `hubs` variable to add authorization keys."
  type = list(object({
    name   = string
    listen = bool
    send   = bool
    manage = bool
  }))
  default = []
}

variable "hubs" {
  description = "A list of event hubs to add to namespace."
  type = list(object({
    name              = string
    partitions        = number
    message_retention = number
    consumers         = list(string)
    keys = list(object({
      name   = string
      listen = bool
      send   = bool
    }))
  }))
  default = []
}
