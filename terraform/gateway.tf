
# HTTP API Gateway

resource "aws_apigatewayv2_api" "grant" {
  name          = "grant-oauth"
  description   = "OAuth Simplified"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "grant" {
  api_id      = aws_apigatewayv2_api.grant.id
  name        = "grant"
  auto_deploy = true
}

# Grant

resource "aws_apigatewayv2_integration" "proxy" {
  api_id             = aws_apigatewayv2_api.grant.id
  description        = "Grant OAuth Proxy"
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.grant.invoke_arn
  payload_format_version = var.event_format
  # https://github.com/terraform-providers/terraform-provider-aws/issues/11148
  lifecycle {
    ignore_changes = [passthrough_behavior]
  }
}

resource "aws_apigatewayv2_route" "proxy" {
  api_id    = aws_apigatewayv2_api.grant.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.proxy.id}"
}

# Permissions

resource "aws_lambda_permission" "grant" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.grant.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.grant.id}/*/*/*"
}

# -----------------------------------------------------------------------------

# Callback - Google

resource "aws_apigatewayv2_integration" "hello" {
  count              = local.callback
  api_id             = aws_apigatewayv2_api.grant.id
  description        = "Grant Callback"
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.callback.0.invoke_arn
  payload_format_version = var.event_format
  # https://github.com/terraform-providers/terraform-provider-aws/issues/11148
  lifecycle {
    ignore_changes = [passthrough_behavior]
  }
}

resource "aws_apigatewayv2_route" "hello" {
  count     = local.callback
  api_id    = aws_apigatewayv2_api.grant.id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.hello.0.id}"
}

# Callback - Twitter

resource "aws_apigatewayv2_integration" "hi" {
  count              = local.callback
  api_id             = aws_apigatewayv2_api.grant.id
  description        = "Grant Callback"
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.callback.0.invoke_arn
  payload_format_version = var.event_format
  # https://github.com/terraform-providers/terraform-provider-aws/issues/11148
  lifecycle {
    ignore_changes = [passthrough_behavior]
  }
}

resource "aws_apigatewayv2_route" "hi" {
  count     = local.callback
  api_id    = aws_apigatewayv2_api.grant.id
  route_key = "GET /hi"
  target    = "integrations/${aws_apigatewayv2_integration.hi.0.id}"
}

# Permissions

resource "aws_lambda_permission" "callback" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.grant.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.grant.id}/*/*/*"
}
