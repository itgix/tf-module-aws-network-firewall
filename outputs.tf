output "network_firewall_id_out" {
  description = "Created Network Firewall ID from network_firewall module"
  value       = aws_networkfirewall_firewall.main.id
}

output "network_firewall_arn_out" {
  description = "Created Network Firewall ARN from network_firewall module"
  value       = aws_networkfirewall_firewall.main.arn
}

output "network_firewall_policy_arn" {
  description = "ARN of the firewall policy"
  value       = aws_networkfirewall_firewall_policy.main.arn
}

# Network function attachment that AWS creates on the Transit Gateway for this firewall.
# Use it as the target of Transit Gateway routes that must be inspected and associate it
# with the Transit Gateway route table that holds the post-inspection routes.
output "transit_gateway_attachment_id" {
  description = "ID of the Transit Gateway network function attachment of the firewall"
  value       = try(aws_networkfirewall_firewall.main.firewall_status[0].transit_gateway_attachment_sync_states[0].attachment_id, null)
}

output "transit_gateway_owner_account_id" {
  description = "AWS account ID that owns the Transit Gateway the firewall is attached to"
  value       = aws_networkfirewall_firewall.main.transit_gateway_owner_account_id
}
