# General
variable "transit_gateway_id" {
  description = "ID of the Transit Gateway the firewall is attached to. Either a Transit Gateway owned by this account or one shared with it through AWS RAM. Changing it replaces the firewall."
  type        = string
}

variable "availability_zone_ids" {
  description = "Availability Zone IDs (e.g. euc1-az1, not AZ names) in which firewall endpoints are created. The Transit Gateway must already be enabled in these AZs, i.e. it must have a VPC attachment with a subnet in each of them."
  type        = list(string)

  validation {
    condition     = length(var.availability_zone_ids) > 0
    error_message = "At least one Availability Zone ID is required."
  }
}

variable "firewall_description" {
  description = "Description of the firewall"
  type        = string
  default     = null
}

variable "delete_protection" {
  description = "Protect the firewall against deletion. Must be set to false (and applied) before the firewall can be destroyed."
  type        = bool
  default     = false
}

variable "availability_zone_change_protection" {
  description = "Protect the firewall against changes to its Availability Zone configuration."
  type        = bool
  default     = false
}

variable "home_net_cidrs" {
  description = "CIDRs set as the firewall policy HOME_NET variable. Required for Transit Gateway attached firewalls when rule groups rely on the default HOME_NET (e.g. domain list rule groups). Empty list = not set."
  type        = list(string)
  default     = []
}

variable "fivetuple_stateful_rule_group" {
  description = "Config for 5-tuple type stateful rule group"
  type        = list(any)
  default     = []
}

variable "domain_stateful_rule_group" {
  description = "Config for domain type stateful rule group"
  type        = list(any)
  default     = []
}

variable "suricata_stateful_rule_group" {
  description = "Config for Suricata type stateful rule group"
  type        = list(any)
  default     = []
}

variable "stateless_rule_group" {
  description = "Config for stateless rule group"
  type        = list(any)
}

variable "firewall_name" {
  description = "firewall name"
  type        = string
  default     = "example"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
  default     = {}
}

variable "stateless_default_actions" {
  description = "Default stateless Action"
  type        = string
  default     = "forward_to_sfe"
}

variable "stateful_engine_rule_order" {
  description = "Stateful engine rule order. Only STRICT_ORDER is supported."
  type        = string
  default     = "STRICT_ORDER"

  validation {
    condition     = var.stateful_engine_rule_order == "STRICT_ORDER"
    error_message = "stateful_engine_rule_order must be STRICT_ORDER."
  }
}

variable "stateful_default_actions" {
  description = "Default action(s) for packets that match no stateful rule, e.g. [\"aws:drop_established_app_layer\"]."
  type        = list(string)
  default     = []
}

variable "stateless_fragment_default_actions" {
  description = "Default Stateless action for fragmented packets"
  type        = string
  default     = "forward_to_sfe"
}


# Logging
variable "netfw_cloudwatch_logs_enabled" {
  description = "Weather to enable Cloudwatch logs for Network firewall"
  type        = bool
  default     = false
}

variable "netfw_cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group for Network Firewall logs"
  type        = number
  default     = 365
}

variable "netfw_s3_logs_enabled" {
  description = "Weather to enable S3 logs for Network firewall"
  type        = bool
  default     = false
}

variable "netfw_kinesis_logs_enabled" {
  description = "Weather to enable Kinesis Data Firehose for sending Network firewall logs"
  type        = bool
  default     = false
}

variable "netfw_cloudwatch_log_group_name" {
  description = "Name of the Cloudwatch log group to be used for Network firewall logs"
  type        = string
}

variable "netfw_log_type" {
  description = "Type of logs to be enabled on Networkfirewall - supported options are ALERT and FLOW"
  type        = string
  default     = "ALERT"
}

variable "netfw_s3_log_bucket_name" {
  description = "Name of the S3 bucket to store logs"
  type        = string
  default     = "netfw_logs"
}

variable "netfw_kinesis_firehose_delivery_stream" {
  description = "Name of Kinesis Data Firehose to be used for Network Firewall logs"
  type        = string
  default     = ""
}

variable "enable_analysis_types" {
  type        = list(any)
  default     = []
  description = "Wether to enable traffic analysis mode - Collects data on frequently accessed domains observed in customer traffic to generate a domain insights report and create domain-based firewall rules. You can generate reports in the Monitoring and observability tab of your firewall."
}
