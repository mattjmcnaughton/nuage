# SNS Topic for alerts - Only create if any alert is enabled
resource "aws_sns_topic" "alarm_topic" {
  count = var.enable_cost_alert || var.enable_runtime_alert ? 1 : 0

  name = "${var.instance_name}-alarm-topic"
  tags = var.tags
}

# Subscribe email to the SNS topic - Only create if any alert is enabled
resource "aws_sns_topic_subscription" "email_subscription" {
  count = var.enable_cost_alert || var.enable_runtime_alert ? 1 : 0

  topic_arn = aws_sns_topic.alarm_topic[0].arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Cost budget alert - Only create if cost alert is enabled
resource "aws_budgets_budget" "cost_budget" {
  count = var.enable_cost_alert ? 1 : 0

  name              = "${var.instance_name}-budget"
  budget_type       = "COST"
  limit_amount      = tostring(var.max_budget)
  limit_unit        = "USD"
  time_period_start = "2023-01-01_00:00"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }
}

# Runtime alarm - Only create if runtime alert is enabled
resource "aws_cloudwatch_metric_alarm" "instance_runtime_alarm" {
  count = var.enable_runtime_alert ? 1 : 0

  alarm_name          = "${var.instance_name}-runtime-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckPassed"
  namespace           = "AWS/EC2"
  period              = var.max_runtime_hours * 3600 # Convert hours to seconds
  statistic           = "Minimum"
  threshold           = 0
  alarm_description   = "This alarm triggers when the instance has been running for more than ${var.max_runtime_hours} hours"
  alarm_actions       = [aws_sns_topic.alarm_topic[0].arn]
  ok_actions          = [aws_sns_topic.alarm_topic[0].arn]

  dimensions = {
    InstanceId = aws_instance.instance.id
  }

  tags = var.tags
}
