## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| authorization\_rules | Authorization rules to add to the namespace. For hub use `hubs` variable to add authorization keys. | <pre>list(object({<br>    name   = string<br>    listen = bool<br>    send   = bool<br>    manage = bool<br>  }))</pre> | `[]` | no |
| auto\_inflate | Is Auto Inflate enabled for the EventHub Namespace, and what is maximum throughput? | <pre>object({<br>    enabled                  = bool<br>    maximum_throughput_units = number<br>  })</pre> | `null` | no |
| capacity | Specifies the Capacity / Throughput Units for a Standard SKU namespace. Valid values range from 1 - 20. | `number` | `1` | no |
| custom\_name | Override default naming convention | `string` | `null` | no |
| deployment\_mode | Specifies how the infrastructure/resource is deployed | `string` | `"terraform"` | no |
| enable\_authorization\_rule | Flag to control attaching Authorization Rule within a Eventhub. | `bool` | `false` | no |
| enable\_consumer\_group | Flag to control attaching Consumer Groups within an Event Hub. | `bool` | `false` | no |
| enabled | Flag to control the module creation | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | n/a | yes |
| extra\_tags | Variable to pass extra tags. | `map(string)` | `null` | no |
| hubs | A list of event hubs to add to namespace. | <pre>list(object({<br>    name              = string<br>    partitions        = number<br>    message_retention = number<br>    consumers         = list(string)<br>    keys = list(object({<br>      name   = string<br>      listen = bool<br>      send   = bool<br>    }))<br>  }))</pre> | `[]` | no |
| label\_order | The order of labels used to construct resource names or tags. If not specified, defaults to ['name', 'environment', 'location']. | `list(any)` | <pre>[<br>  "name",<br>  "environment",<br>  "location"<br>]</pre> | no |
| location | Azure location where resources should be deployed. | `string` | `""` | no |
| managedby | ManagedBy, eg 'terraform-az-modules'. | `string` | `"terraform-az-modules"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | n/a | yes |
| network\_rules | Network rules restricting access to the event hub. | <pre>object({<br>    ip_rules   = list(string)<br>    subnet_ids = list(string)<br>  })</pre> | `null` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/terraform-az-modules/terraform-azure-eventhub"` | no |
| resource\_group\_name | Name of resource group to deploy resources in. | `string` | `""` | no |
| resource\_position\_prefix | Controls the placement of the resource type keyword (e.g., "vnet", "ddospp") in the resource name.<br><br>- If true, the keyword is prepended: "vnet-core-dev".<br>- If false, the keyword is appended: "core-dev-vnet".<br><br>This helps maintain naming consistency based on organizational preferences. | `bool` | `true` | no |
| sku | Defines which tier to use. Valid options are Basic and Standard. | `string` | `"Standard"` | no |

## Outputs

| Name | Description |
|------|-------------|
| authorization\_keys | Map of authorization keys with their ids. |
| eventhub\_name | Map of hubs and their names. |
| eventhub\_namespace\_name | Name of Event Hub |
| hub\_ids | Map of hubs and their ids. |
| keys | Map of hubs with keys => primary\_key / secondary\_key mapping. |
| namespace\_id | Id of Event Hub Namespace. |

