output "web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = try(aws_wafv2_web_acl.main[0].arn, null)
}

output "web_acl_id" {
  description = "ID of the WAF Web ACL"
  value       = try(aws_wafv2_web_acl.main[0].id, null)
}

output "web_acl_capacity" {
  description = "Current capacity of the WAF Web ACL"
  value       = try(aws_wafv2_web_acl.main[0].capacity, null)
}

output "alb_associations" {
  description = "Map of ALB ARNs and their WAF association IDs"
  value       = { for k, v in aws_wafv2_web_acl_association.alb : k => v.id }
}

output "log_group_name" {
  description = "Name of the CloudWatch log group for WAF logs"
  value       = try(aws_cloudwatch_log_group.waf[0].name, null)
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group for WAF logs"
  value       = try(aws_cloudwatch_log_group.waf[0].arn, null)
}
