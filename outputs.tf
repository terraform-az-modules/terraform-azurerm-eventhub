output "eventhub_namespace_name" {
  description = "Name of Event Hub"
  value       = try(azurerm_eventhub_namespace.eventhub_ns[0].name, null)
}

output "namespace_id" {
  description = "Id of Event Hub Namespace."
  value       = try(azurerm_eventhub_namespace.eventhub_ns[0].id, null)
}

output "eventhub_name" {
  description = "Map of hubs and their names."
  value       = { for k, v in azurerm_eventhub.eventhub : k => v.name }
}

output "hub_ids" {
  description = "Map of hubs and their ids."
  value       = { for k, v in azurerm_eventhub.eventhub : k => v.id }
}

output "keys" {
  description = "Map of hubs with keys => primary_key / secondary_key mapping."
  sensitive   = true
  value = { for k, h in azurerm_eventhub_authorization_rule.eventhub_ar : h.name => {
    primary_key   = h.primary_key
    secondary_key = h.secondary_key
    }
  }
}

output "authorization_keys" {
  description = "Map of authorization keys with their ids."
  value       = { for a in azurerm_eventhub_namespace_authorization_rule.eventhub_nar : a.name => a.id }
}
