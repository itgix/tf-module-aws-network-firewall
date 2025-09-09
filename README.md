# aws network-firewall

The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.netfw_cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_networkfirewall_firewall.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall) | resource |
| [aws_networkfirewall_firewall_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy) | resource |
| [aws_networkfirewall_logging_configuration.cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_logging_configuration) | resource |
| [aws_networkfirewall_logging_configuration.kinesis_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_logging_configuration) | resource |
| [aws_networkfirewall_logging_configuration.s3_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_logging_configuration) | resource |
| [aws_networkfirewall_rule_group.domain_stateful_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.fivetuple_stateful_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.stateless_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_networkfirewall_rule_group.suricata_stateful_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_default_tags.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | List of availability zones used by the firewall | `list(string)` | n/a | yes |
| <a name="input_domain_stateful_rule_group"></a> [domain\_stateful\_rule\_group](#input\_domain\_stateful\_rule\_group) | Config for domain type stateful rule group | `list(any)` | `[]` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | firewall name | `string` | `"example"` | no |
| <a name="input_fivetuple_stateful_rule_group"></a> [fivetuple\_stateful\_rule\_group](#input\_fivetuple\_stateful\_rule\_group) | Config for 5-tuple type stateful rule group | `list(any)` | `[]` | no |
| <a name="input_netfw_cloudwatch_log_group_name"></a> [netfw\_cloudwatch\_log\_group\_name](#input\_netfw\_cloudwatch\_log\_group\_name) | Name of the Cloudwatch log group to be used for Network firewall logs | `string` | n/a | yes |
| <a name="input_netfw_cloudwatch_logs_enabled"></a> [netfw\_cloudwatch\_logs\_enabled](#input\_netfw\_cloudwatch\_logs\_enabled) | Weather to enable Cloudwatch logs for Network firewall | `bool` | `false` | no |
| <a name="input_netfw_kinesis_firehose_delivery_stream"></a> [netfw\_kinesis\_firehose\_delivery\_stream](#input\_netfw\_kinesis\_firehose\_delivery\_stream) | Name of Kinesis Data Firehose to be used for Network Firewall logs | `string` | `""` | no |
| <a name="input_netfw_kinesis_logs_enabled"></a> [netfw\_kinesis\_logs\_enabled](#input\_netfw\_kinesis\_logs\_enabled) | Weather to enable Kinesis Data Firehose for sending Network firewall logs | `bool` | `false` | no |
| <a name="input_netfw_log_type"></a> [netfw\_log\_type](#input\_netfw\_log\_type) | Type of logs to be enabled on Networkfirewall - supported options are ALERT and FLOW | `string` | `"ALERT"` | no |
| <a name="input_netfw_s3_log_bucket_name"></a> [netfw\_s3\_log\_bucket\_name](#input\_netfw\_s3\_log\_bucket\_name) | Name of the S3 bucket to store logs | `string` | `"netfw_logs"` | no |
| <a name="input_netfw_s3_logs_enabled"></a> [netfw\_s3\_logs\_enabled](#input\_netfw\_s3\_logs\_enabled) | Weather to enable S3 logs for Network firewall | `bool` | `false` | no |
| <a name="input_stateless_default_actions"></a> [stateless\_default\_actions](#input\_stateless\_default\_actions) | Default stateless Action | `string` | `"forward_to_sfe"` | no |
| <a name="input_stateless_fragment_default_actions"></a> [stateless\_fragment\_default\_actions](#input\_stateless\_fragment\_default\_actions) | Default Stateless action for fragmented packets | `string` | `"forward_to_sfe"` | no |
| <a name="input_stateless_rule_group"></a> [stateless\_rule\_group](#input\_stateless\_rule\_group) | Config for stateless rule group | `list(any)` | n/a | yes |
| <a name="input_subnet_mapping"></a> [subnet\_mapping](#input\_subnet\_mapping) | Subnet ids mapping to have individual firewall endpoint | `any` | n/a | yes |
| <a name="input_suricata_stateful_rule_group"></a> [suricata\_stateful\_rule\_group](#input\_suricata\_stateful\_rule\_group) | Config for Suricata type stateful rule group | `list(any)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_firewall_arn_out"></a> [network\_firewall\_arn\_out](#output\_network\_firewall\_arn\_out) | Created Network Firewall ARN from network\_firewall module |
| <a name="output_network_firewall_endpoint_id"></a> [network\_firewall\_endpoint\_id](#output\_network\_firewall\_endpoint\_id) | Created Network Firewall endpoint id |
| <a name="output_network_firewall_endpoint_ids"></a> [network\_firewall\_endpoint\_ids](#output\_network\_firewall\_endpoint\_ids) | Ordered list of Network Firewall endpoint IDs per AZ |
| <a name="output_network_firewall_id_out"></a> [network\_firewall\_id\_out](#output\_network\_firewall\_id\_out) | Created Network Firewall ID from network\_firewall module |
<!-- END_TF_DOCS -->
