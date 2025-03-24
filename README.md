# AWS WAF OFAC Countries Blocking Module

This Terraform module creates an AWS WAF Web ACL that blocks traffic from OFAC sanctioned countries and can be associated with multiple Application Load Balancers (ALBs).

## Features

- Blocks traffic from OFAC sanctioned countries
- Supports multiple ALB associations
- Configurable IP rate limiting
- Optional CloudWatch logging
- Customizable blocked country list
- Flexible enable/disable functionality

## Usage

```hcl
module "ofac_waf" {
  source = "path/to/terraform-aws-ofac-waf"

  alb_arns = [
    "arn:aws:elasticloadbalancing:region:account:loadbalancer/app/alb1/1234567890",
    "arn:aws:elasticloadbalancing:region:account:loadbalancer/app/alb2/0987654321"
  ]
  
  waf_name    = "my-ofac-waf"
  enable_logging = true
  
  # Optional: Add more countries to block
  additional_blocked_countries = ["XX", "YY"]
  
  # Optional: Customize rate limiting
  rate_limit = 2000
  
  # Optional: Add tags
  tags = {
    Environment = "production"
    Project     = "security"
  }
}
```

## Requirements

- Terraform >= 1.0.0
- AWS Provider >= 4.0.0
- AWS WAFv2 permissions
- AWS CloudWatch permissions (if logging is enabled)

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| alb_arns | List of ALB ARNs to associate with WAF | list(string) | - | yes |
| enabled | Enable/disable the WAF protection | bool | true | no |
| waf_name | Name for the WAF Web ACL | string | "ofac-country-blocks" | no |
| additional_blocked_countries | Additional countries to block | list(string) | [] | no |
| enable_logging | Enable WAF logging to CloudWatch | bool | true | no |
| rate_limit | Number of requests allowed from an IP in 5 minutes | number | 2000 | no |
| log_retention_days | Number of days to retain WAF logs | number | 30 | no |
| tags | Tags to apply to all resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| web_acl_arn | ARN of the WAF Web ACL |
| web_acl_id | ID of the WAF Web ACL |
| web_acl_capacity | Current capacity of the WAF Web ACL |
| alb_associations | Map of ALB ARNs and their WAF association IDs |
| log_group_name | Name of the CloudWatch log group for WAF logs |
| log_group_arn | ARN of the CloudWatch log group for WAF logs |

## OFAC Sanctioned Countries

The module blocks traffic from the following OFAC sanctioned countries by default:
- Cuba (CU)
- Iran (IR)
- North Korea (KP)
- Syria (SY)
- Russia (RU)
- Belarus (BY)
- Myanmar/Burma (MM)
- Venezuela (VE)
- Nicaragua (NI)

Additional countries can be added using the `additional_blocked_countries` variable.

## Notes

- The module creates a regional WAF Web ACL suitable for ALB associations
- IP rate limiting is applied after the country blocking rules
- CloudWatch logs will only include blocked requests when enabled
- Changes to the WAF rules may take a few minutes to propagate

## License

This module is released under the MIT License.
