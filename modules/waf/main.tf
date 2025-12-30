# WAF Web ACL for CloudFront
resource "aws_wafv2_web_acl" "cloudfront" {
  provider    = aws
  name        = "${var.project_name}-${var.environment}-cloudfront-waf"
  description = "WAF for CloudFront distribution"
  scope       = "CLOUDFRONT"
  
  default_action {
    allow {}
  }
  
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1
    
    override_action {
      none {}
    }
    
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-${var.environment}-common-rule-set"
      sampled_requests_enabled   = true
    }
  }
  
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2
    
    override_action {
      none {}
    }
    
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-${var.environment}-bad-inputs-rule-set"
      sampled_requests_enabled   = true
    }
  }
  
  rule {
    name     = "RateLimitRule"
    priority = 3
    
    action {
      block {}
    }
    
    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }
    
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-${var.environment}-rate-limit"
      sampled_requests_enabled   = true
    }
  }
  
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-${var.environment}-cloudfront-waf"
    sampled_requests_enabled   = true
  }
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-cloudfront-waf"
    Environment = var.environment
    Project     = var.project_name
  }
}

# WAF Web ACL for ALB
resource "aws_wafv2_web_acl" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-waf"
  description = "WAF for Application Load Balancer"
  scope       = "REGIONAL"
  
  default_action {
    allow {}
  }
  
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1
    
    override_action {
      none {}
    }
    
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-${var.environment}-alb-common-rule-set"
      sampled_requests_enabled   = true
    }
  }
  
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 2
    
    override_action {
      none {}
    }
    
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-${var.environment}-alb-sqli-rule-set"
      sampled_requests_enabled   = true
    }
  }
  
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-${var.environment}-alb-waf"
    sampled_requests_enabled   = true
  }
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-alb-waf"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Associate WAF with CloudFront
resource "aws_wafv2_web_acl_association" "cloudfront" {
  count        = var.cloudfront_arn != "" ? 1 : 0
  resource_arn = var.cloudfront_arn
  web_acl_arn  = aws_wafv2_web_acl.cloudfront.arn
}

# Associate WAF with ALB
resource "aws_wafv2_web_acl_association" "alb" {
  count        = var.alb_arn != "" ? 1 : 0
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.alb.arn
}
