The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

# AWS Network Firewall Terraform Module

This module deploys AWS Network Firewall with stateful and stateless rule groups, configurable logging (CloudWatch, S3, Kinesis), and traffic analysis support.

Part of the [ITGix AWS Landing Zone](https://itgix.com/itgix-landing-zone/).

## Resources Created

- AWS Network Firewall with VPC endpoint(s)
- Firewall policy with stateful and stateless rule groups
- Stateful rule groups (5-tuple, domain, Suricata)
- Stateless rule groups
- Logging configuration (CloudWatch, S3, Kinesis Data Firehose)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `azs` | List of availability zones used by the firewall | `list(string)` | — | yes |
| `firewall_name` | Firewall name | `string` | `"example"` | no |
| `vpc_id` | VPC ID | `string` | — | yes |
| `subnet_mapping` | Subnet IDs mapping for firewall endpoints | `any` | — | yes |
| `tags` | A map of tags to add to all resources | `map(any)` | `{}` | no |
| `fivetuple_stateful_rule_group` | Config for 5-tuple type stateful rule group | `list(any)` | `[]` | no |
| `domain_stateful_rule_group` | Config for domain type stateful rule group | `list(any)` | `[]` | no |
| `suricata_stateful_rule_group` | Config for Suricata type stateful rule group | `list(any)` | `[]` | no |
| `stateless_rule_group` | Config for stateless rule group | `list(any)` | — | yes |
| `stateless_default_actions` | Default stateless action | `string` | `"forward_to_sfe"` | no |
| `stateless_fragment_default_actions` | Default stateless action for fragmented packets | `string` | `"forward_to_sfe"` | no |
| `netfw_cloudwatch_logs_enabled` | Enable CloudWatch logs for Network Firewall | `bool` | `false` | no |
| `netfw_s3_logs_enabled` | Enable S3 logs for Network Firewall | `bool` | `false` | no |
| `netfw_kinesis_logs_enabled` | Enable Kinesis Data Firehose for Network Firewall logs | `bool` | `false` | no |
| `netfw_cloudwatch_log_group_name` | CloudWatch log group name for firewall logs | `string` | — | yes |
| `netfw_log_type` | Type of logs (ALERT or FLOW) | `string` | `"ALERT"` | no |
| `netfw_s3_log_bucket_name` | S3 bucket name for firewall logs | `string` | `"netfw_logs"` | no |
| `netfw_kinesis_firehose_delivery_stream` | Kinesis Data Firehose delivery stream name | `string` | `""` | no |
| `enable_analysis_types` | Enable traffic analysis mode | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `network_firewall_id_out` | Network Firewall ID |
| `network_firewall_arn_out` | Network Firewall ARN |
| `network_firewall_endpoint_id` | Network Firewall endpoint IDs |
| `network_firewall_endpoint_ids` | Ordered list of Network Firewall endpoint IDs per AZ |

## Usage Example

```hcl
module "network_firewall" {
  source = "path/to/tf-module-aws-network-firewall"

  firewall_name = "my-firewall"
  vpc_id        = "vpc-0abc1234def567890"
  azs           = ["eu-central-1a", "eu-central-1b"]

  subnet_mapping = [
    { subnet_id = "subnet-aaa111" },
    { subnet_id = "subnet-bbb222" }
  ]

  stateless_rule_group = []

  netfw_cloudwatch_logs_enabled  = true
  netfw_cloudwatch_log_group_name = "/aws/network-firewall/my-firewall"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```
