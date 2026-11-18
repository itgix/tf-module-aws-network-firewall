# Network firewall service - Transit Gateway attached.
# AWS provisions the firewall endpoints in an AWS-managed VPC and exposes the firewall to
# the Transit Gateway as a network function attachment. No inspection VPC, firewall
# subnets or VPC route tables are required; traffic is steered to the firewall purely with
# Transit Gateway route tables (see the transit_gateway_attachment_id output).
resource "aws_networkfirewall_firewall" "main" {
  name                   = var.firewall_name
  description            = var.firewall_description
  firewall_policy_arn    = aws_networkfirewall_firewall_policy.main.arn
  transit_gateway_id     = var.transit_gateway_id
  enabled_analysis_types = var.enable_analysis_types

  # One firewall endpoint per AZ. The Transit Gateway must already have a VPC attachment
  # in each of these AZs, otherwise the firewall creation fails.
  dynamic "availability_zone_mapping" {
    for_each = toset(var.availability_zone_ids)
    content {
      availability_zone_id = availability_zone_mapping.value
    }
  }

  delete_protection                   = var.delete_protection
  availability_zone_change_protection = var.availability_zone_change_protection

  tags = merge(var.tags)
}

# Network Firewall Policy
resource "aws_networkfirewall_firewall_policy" "main" {
  name = var.firewall_name

  firewall_policy {
    stateless_default_actions          = ["aws:${var.stateless_default_actions}"]
    stateless_fragment_default_actions = ["aws:${var.stateless_fragment_default_actions}"]

    stateful_engine_options {
      rule_order = var.stateful_engine_rule_order
    }

    stateful_default_actions = var.stateful_default_actions

    # Policy-level HOME_NET. A Transit Gateway attached firewall has no customer VPC whose
    # CIDR could serve as the default HOME_NET, so AWS requires HOME_NET to be set
    # explicitly for rule groups that rely on it (e.g. domain list rule groups).
    # Rule groups that define their own HOME_NET keep using their own value.
    dynamic "policy_variables" {
      for_each = length(var.home_net_cidrs) > 0 ? [1] : []
      content {
        rule_variables {
          key = "HOME_NET"
          ip_set {
            definition = var.home_net_cidrs
          }
        }
      }
    }

    # Stateless Rule Group Reference
    dynamic "stateless_rule_group_reference" {
      for_each = local.this_stateless_group_arn
      content {
        # Priority is sequentially as per index in stateless_rule_group list 
        priority     = index(local.this_stateless_group_arn, stateless_rule_group_reference.value) + 1
        resource_arn = stateless_rule_group_reference.value
      }
    }

    # StateFul Rule Group Reference
    dynamic "stateful_rule_group_reference" {
      for_each = local.this_stateful_group_arn
      content {
        resource_arn = stateful_rule_group_reference.value
        # Required for STRICT_ORDER (evaluation order between rule groups)
        priority = index(local.this_stateful_group_arn, stateful_rule_group_reference.value) + 1
      }
    }
  }
  tags = merge(var.tags)
}
