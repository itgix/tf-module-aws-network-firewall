The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

# AWS Network Firewall Terraform Module

This module deploys a **Transit Gateway attached** AWS Network Firewall with stateful and stateless rule groups, configurable logging (CloudWatch, S3, Kinesis), and traffic analysis support.

The firewall is attached directly to an AWS Transit Gateway as a network function attachment. AWS manages the firewall endpoints in an AWS-owned VPC, so no inspection VPC, firewall subnets or VPC route tables are needed. Traffic is steered through the firewall with Transit Gateway route tables only.

Part of the [ITGix AWS Landing Zone](https://itgix.com/itgix-landing-zone/).

> **v4.0.0 breaking change:** VPC attached firewalls (`vpc_id`, `subnet_mapping`, `azs`) are no longer supported. Keep using `v3.x` for a VPC attached firewall. Switching an existing firewall from VPC attached to Transit Gateway attached replaces the firewall; see "Migrating from a VPC attached firewall" below.

## Resources Created

- AWS Network Firewall attached to a Transit Gateway (one endpoint per Availability Zone)
- Firewall policy with stateful and stateless rule groups (optionally with a policy-level `HOME_NET`)
- Stateful rule groups (5-tuple, domain, Suricata)
- Stateless rule groups
- Logging configuration (CloudWatch, S3, Kinesis Data Firehose)

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.5.7 |
| AWS provider | >= 6.5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `transit_gateway_id` | Transit Gateway the firewall is attached to (own or shared via RAM). Changing it replaces the firewall. | `string` | — | yes |
| `availability_zone_ids` | AZ **IDs** (e.g. `euc1-az1`) for the firewall endpoints. The Transit Gateway must have a VPC attachment in each of them. | `list(string)` | — | yes |
| `firewall_name` | Firewall name (also used for the firewall policy) | `string` | `"example"` | no |
| `firewall_description` | Firewall description | `string` | `null` | no |
| `delete_protection` | Protect the firewall against deletion | `bool` | `false` | no |
| `availability_zone_change_protection` | Protect the firewall against AZ configuration changes | `bool` | `false` | no |
| `home_net_cidrs` | CIDRs set as the policy-level `HOME_NET` variable. Needed for rule groups that rely on the default `HOME_NET` (e.g. domain list rule groups). | `list(string)` | `[]` | no |
| `tags` | A map of tags to add to all resources | `map(any)` | `{}` | no |
| `fivetuple_stateful_rule_group` | Config for 5-tuple type stateful rule group | `list(any)` | `[]` | no |
| `domain_stateful_rule_group` | Config for domain type stateful rule group | `list(any)` | `[]` | no |
| `suricata_stateful_rule_group` | Config for Suricata type stateful rule group | `list(any)` | `[]` | no |
| `stateless_rule_group` | Config for stateless rule group | `list(any)` | — | yes |
| `stateless_default_actions` | Default stateless action | `string` | `"forward_to_sfe"` | no |
| `stateless_fragment_default_actions` | Default stateless action for fragmented packets | `string` | `"forward_to_sfe"` | no |
| `stateful_engine_rule_order` | Stateful engine rule order (only `STRICT_ORDER`) | `string` | `"STRICT_ORDER"` | no |
| `stateful_default_actions` | Default action(s) for packets that match no stateful rule | `list(string)` | `[]` | no |
| `netfw_cloudwatch_logs_enabled` | Enable CloudWatch logs for Network Firewall | `bool` | `false` | no |
| `netfw_cloudwatch_log_group_retention_in_days` | Retention of the CloudWatch log group | `number` | `365` | no |
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
| `network_firewall_policy_arn` | Firewall policy ARN |
| `transit_gateway_attachment_id` | Transit Gateway network function attachment ID of the firewall. Route traffic to it and associate it with the post-inspection TGW route table. |
| `transit_gateway_owner_account_id` | Account that owns the Transit Gateway |

## Routing

The module does not manage Transit Gateway routing. With the firewall attachment ID:

1. Associate the firewall attachment with a TGW route table that holds the routes *after* inspection (return routes to every VPC and `0.0.0.0/0` to the egress VPC).
2. Point the `0.0.0.0/0` (and `::/0`) routes of the spoke / shared route tables at the firewall attachment.

Appliance mode is always enabled on Transit Gateway attached firewalls, so flow symmetry across AZs is handled by AWS. Only static routes can target the firewall attachment.

## Usage Example

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}

module "network_firewall" {
  source = "git::https://github.com/itgix/tf-module-aws-network-firewall.git?ref=v4.0.0"

  firewall_name         = "my-firewall"
  transit_gateway_id    = "tgw-0abc1234def567890"
  availability_zone_ids = slice(data.aws_availability_zones.available.zone_ids, 0, 3)

  home_net_cidrs = ["10.0.0.0/10"]

  stateless_rule_group = []

  netfw_cloudwatch_logs_enabled   = true
  netfw_cloudwatch_log_group_name = "/aws/network-firewall/my-firewall"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Send traffic of a spoke route table through the firewall
resource "aws_ec2_transit_gateway_route" "spoke_default" {
  transit_gateway_route_table_id = "tgw-rtb-0123456789abcdef0"
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.network_firewall.transit_gateway_attachment_id
}
```

## Migrating from a VPC attached firewall

`transit_gateway_id` / `vpc_id` force a new firewall, and firewall, policy and rule group names must be unique per account and Region. Upgrading a `v3.x` module call in place therefore cannot be done without an outage. Instead, run both firewalls side by side:

1. Keep the existing firewall on a `v3.x` module call (rename the call with `moved` blocks if needed).
2. Add a new `v4.x` module call with **different** firewall, policy and rule group names.
3. Cut the Transit Gateway routes over to the new firewall attachment in a maintenance window.
4. Decommission the old firewall and the inspection VPC once traffic is verified.

See the [AWS migration guide](https://aws.amazon.com/blogs/security/why-and-how-to-migrate-to-a-transit-gateway-attached-aws-network-firewall/) for background.
