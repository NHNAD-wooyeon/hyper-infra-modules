resource "aws_lambda_function" "this" {
  function_name                  = var.function_name
  role                          = var.role_arn != null ? var.role_arn : aws_iam_role.lambda_role[0].arn
  handler                       = var.package_type == "Zip" ? var.handler : null
  source_code_hash             = var.source_code_hash
  runtime                      = var.package_type == "Zip" ? var.runtime : null
  timeout                      = var.timeout
  memory_size                  = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  publish                      = var.publish
  description                  = var.description
  kms_key_arn                 = var.kms_key_arn
  layers                      = var.layers
  package_type                = var.package_type
  architectures               = var.architectures
  filename                    = var.filename
  s3_bucket                   = var.s3_bucket
  s3_key                      = var.s3_key
  s3_object_version           = var.s3_object_version
  image_uri                   = var.image_uri

  dynamic "environment" {
    for_each = var.environment_variables != null ? [var.environment_variables] : []
    content {
      variables = environment.value
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config != null ? [var.dead_letter_config] : []
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config != null ? [var.tracing_config] : []
    content {
      mode = tracing_config.value.mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = vpc_config.value.security_group_ids
    }
  }

  dynamic "file_system_config" {
    for_each = var.file_system_config != null ? [var.file_system_config] : []
    content {
      arn              = file_system_config.value.arn
      local_mount_path = file_system_config.value.local_mount_path
    }
  }

  dynamic "image_config" {
    for_each = var.image_config != null ? [var.image_config] : []
    content {
      command           = image_config.value.command
      entry_point       = image_config.value.entry_point
      working_directory = image_config.value.working_directory
    }
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda_logs,
  ]
}

resource "aws_iam_role" "lambda_role" {
  count = var.role_arn == null ? 1 : 0
  name  = "${var.function_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  count      = var.role_arn == null ? 1 : 0
  role       = aws_iam_role.lambda_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_execution" {
  count      = var.role_arn == null && var.vpc_config != null ? 1 : 0
  role       = aws_iam_role.lambda_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  count             = var.create_log_group ? 1 : 0
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.log_kms_key_id

  tags = var.tags
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count         = var.cloudwatch_schedule_expression != null ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule[0].arn
}

resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  count               = var.cloudwatch_schedule_expression != null ? 1 : 0
  name                = "${var.function_name}-schedule"
  description         = "Schedule for ${var.function_name}"
  schedule_expression = var.cloudwatch_schedule_expression

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "lambda_schedule" {
  count     = var.cloudwatch_schedule_expression != null ? 1 : 0
  rule      = aws_cloudwatch_event_rule.lambda_schedule[0].name
  target_id = "${var.function_name}-target"
  arn       = aws_lambda_function.this.arn
}