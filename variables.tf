variable "alb_arns" {
  description = "List of Application Load Balancer ARNs to associate with WAF"
  type        = list(string)
}

variable "enabled" {
  description = "Enable/disable the WAF protection"
  type        = bool
  default     = true
}

variable "waf_name" {
  description = "Name for the WAF Web ACL"
  type        = string
  default     = "ofac-country-blocks"
}

variable "additional_blocked_countries" {
  description = "Additional countries to block beyond OFAC list"
  type        = list(string)
  default     = []
}

variable "enable_logging" {
  description = "Enable WAF logging to CloudWatch"
  type        = bool
  default     = true
}

variable "rate_limit" {
  description = "Number of requests allowed from an IP in 5 minutes"
  type        = number
  default     = 2000
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "Number of days to retain WAF logs"
  type        = number
  default     = 30
}

variable "web-acl_scope" {
  description = "Indicate the scrope of the acl"
  type        = string
  default     = "REGIONAL"
}