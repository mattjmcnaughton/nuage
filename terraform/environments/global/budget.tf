locals {
  budget_limit_amount = "200"
  budget_notification_email = "mattjmcnaughton@gmail.com"
}

resource "aws_budgets_budget" "budget" {
  name = "g-budget-monthly"
  budget_type = "COST"
  limit_amount = local.budget_limit_amount
  limit_unit = "USD"
  time_unit = "MONTHLY"
  time_period_start = "2019-12-01_12:00"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold = 80
    threshold_type = "PERCENTAGE"
    notification_type = "ACTUAL"
    subscriber_email_addresses = [
      local.budget_notification_email,
    ]
  }
}
