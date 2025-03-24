locals {
  ofac_countries = [
    "CU", # Cuba
    "IR", # Iran
    "KP", # North Korea
    "SY", # Syria
    "RU", # Russia
    "BY", # Belarus
    "MM", # Myanmar (Burma)
    "VE", # Venezuela
    "NI"  # Nicaragua
  ]
  blocked_countries = distinct(concat(local.ofac_countries, var.additional_blocked_countries))
}

resource "aws_wafv2_web_acl" "main" {
  count = var.enabled ? 1 : 0

  name        = var.waf_name
  description = "WAF Web ACL for blocking OFAC sanctioned countries"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "OFAC-Countries-Block"
    priority = 1

    override_action {
      none {}
    }

    statement {
      geo_match_statement {
        country_codes = local.blocked_countries
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "OFACCountriesBlockMetric"
      sampled_requests_enabled  = true
    }
  }

  rule {
    name     = "IP-Rate-Limit"
    priority = 2

    override_action {
      none {}
    }

    statement {
      rate_based_statement {
        limit              = var.rate_limit
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name               = "IPRateLimitMetric"
      sampled_requests_enabled  = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name               = "WAFWebACLMetric"
    sampled_requests_enabled  = true
  }

  tags = var.tags
}

resource "aws_wafv2_web_acl_association" "alb" {
  for_each = var.enabled ? toset(var.alb_arns) : []

  web_acl_arn = aws_wafv2_web_acl.main[0].arn
  resource_arn = each.value
}

resource "aws_cloudwatch_log_group" "waf" {
  count = var.enabled && var.enable_logging ? 1 : 0

  name              = "/aws/waf/${var.waf_name}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

resource "aws_wafv2_web_acl_logging_configuration" "main" {
  count = var.enabled && var.enable_logging ? 1 : 0

  log_destination_configs = [aws_cloudwatch_log_group.waf[0].arn]
  resource_arn           = aws_wafv2_web_acl.main[0].arn

  logging_filter {
    default_behavior = "KEEP"

    filter {
      behavior = "KEEP"
      condition {
        action_condition {
          action = "BLOCK"
        }
      }
      requirement = "MEETS_ANY"
    }
  }
}
