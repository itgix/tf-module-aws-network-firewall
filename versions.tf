terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # 6.5.0 added transit_gateway_id / availability_zone_mapping (Transit Gateway
      # attached firewalls) to aws_networkfirewall_firewall.
      version = ">= 6.5.0"
    }
  }
}
