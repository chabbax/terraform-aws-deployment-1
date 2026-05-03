# Defines a budget for monthly recurring costs with notifications for actual and forecasted costs exceeding thresholds
resource "aws_budgets_budget" "cost" {
  name         = "Monthly Recurring Cost Before Tax"
  budget_type  = "COST"
  limit_amount = var.cost_budget_limit_amount
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  # Actual cost > 80%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.billing_email_recipients
  }

  # Actual cost > 100%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.billing_email_recipients
  }

  # Actual cost > 105%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 105
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.billing_email_recipients
  }

  # Actual cost > 110%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 110
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.billing_email_recipients
  }


  # Actual cost > 115%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 115
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.billing_email_recipients
  }



  # Forecasted cost > 100%
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.billing_email_recipients
  }

  cost_types {
    # Include: Recurring reservation charges
    include_recurring = true

    # Exclude: Taxes, Refunds, Credits, Upfront reservation fees, Other subscription costs, Support charges, Discounts
    include_tax                = false
    include_refund             = false
    include_credit             = false
    include_upfront            = false
    include_other_subscription = false
    include_subscription       = false
    include_support            = false
    include_discount           = false

    # Cost aggregated by: Unblended costs
    use_blended = false
  }
}
