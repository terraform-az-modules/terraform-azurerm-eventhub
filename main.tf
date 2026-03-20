
##-----------------------------------------------------------------------------
## Labels module callled that will be used for naming and tags.
##-----------------------------------------------------------------------------
module "labels" {
  source          = "terraform-az-modules/tags/azurerm"
  version         = "1.0.2"
  name            = var.custom_name == null ? var.name : var.custom_name
  environment     = var.environment
  location        = var.location
  managedby       = var.managedby
  label_order     = var.label_order
  repository      = var.repository
  deployment_mode = var.deployment_mode
  extra_tags      = var.extra_tags
}

resource "azurerm_eventhub_namespace" "eventhub_ns" {
  count               = var.enabled ? 1 : 0
  name                = format(var.resource_position_prefix ? "event-hub-%s" : "%s-event-hub", local.name)
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  capacity            = var.capacity

  auto_inflate_enabled     = var.auto_inflate != null ? var.auto_inflate.enabled : null
  maximum_throughput_units = var.auto_inflate != null ? var.auto_inflate.maximum_throughput_units : null

  dynamic "network_rulesets" {
    for_each = var.network_rules != null ? ["true"] : []
    content {
      default_action = "Deny"

      dynamic "ip_rule" {
        for_each = var.network_rules != null ? var.network_rules.ip_rules : []
        iterator = iprule
        content {
          ip_mask = iprule.value
        }
      }

      dynamic "virtual_network_rule" {
        for_each = var.network_rules != null ? var.network_rules.subnet_ids : []
        iterator = subnet
        content {
          subnet_id = subnet.value
        }
      }
    }
  }

  tags = module.labels.tags
}

resource "azurerm_eventhub_namespace_authorization_rule" "eventhub_nar" {
  for_each = var.enabled ? local.authorization_rules : {}

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.eventhub_ns[0].name
  resource_group_name = var.resource_group_name

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage
}

resource "azurerm_eventhub" "eventhub" {
  for_each = var.enabled ? local.hubs : {}

  name              = each.key
  namespace_id      = azurerm_eventhub_namespace.eventhub_ns[0].id
  partition_count   = each.value.partitions
  message_retention = each.value.message_retention
}

resource "azurerm_eventhub_consumer_group" "eventhub_cg" {
  for_each = var.enabled && var.enable_consumer_group ? local.consumers : {}

  name                = each.value.name
  namespace_name      = azurerm_eventhub_namespace.eventhub_ns[0].name
  eventhub_name       = each.value.hub
  resource_group_name = var.resource_group_name
  user_metadata       = "terraform"

  depends_on = [azurerm_eventhub.eventhub]
}

resource "azurerm_eventhub_authorization_rule" "eventhub_ar" {
  for_each = var.enabled && var.enable_authorization_rule ? local.keys : {}

  name                = each.value.key.name
  namespace_name      = azurerm_eventhub_namespace.eventhub_ns[0].name
  eventhub_name       = each.value.hub
  resource_group_name = var.resource_group_name

  listen = each.value.key.listen
  send   = each.value.key.send
  manage = false

  depends_on = [azurerm_eventhub.eventhub]
}
