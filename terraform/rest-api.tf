
# REST API Gateway

resource "aws_api_gateway_rest_api" "grant" {
  count       = local.rest_api
  name        = "grant-oauth"
  description = "OAuth Simplified"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "grant" {
  count       = local.rest_api
  rest_api_id = aws_api_gateway_rest_api.grant.0.id
  stage_name  = "grant"
}

# Grant

resource "aws_api_gateway_resource" "grant" {
  count       = local.rest_api
  rest_api_id = aws_api_gateway_rest_api.grant.0.id
  parent_id   = aws_api_gateway_rest_api.grant.0.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "grant" {
  count         = local.rest_api
  rest_api_id   = aws_api_gateway_rest_api.grant.0.id
  resource_id   = aws_api_gateway_resource.grant.0.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "grant" {
  count                   = local.rest_api
  rest_api_id             = aws_api_gateway_rest_api.grant.0.id
  resource_id             = aws_api_gateway_resource.grant.0.id
  http_method             = aws_api_gateway_method.grant.0.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.grant.invoke_arn
}

# Permissions

resource "aws_lambda_permission" "rest_api_grant" {
  count         = local.rest_api
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.grant.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.grant.0.id}/*/*/*"
}

# -----------------------------------------------------------------------------

# Callback - Google

resource "aws_api_gateway_resource" "hello" {
  count       = local.rest_api_callback
  rest_api_id = aws_api_gateway_rest_api.grant.0.id
  parent_id   = aws_api_gateway_rest_api.grant.0.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "hello" {
  count         = local.rest_api_callback
  rest_api_id   = aws_api_gateway_rest_api.grant.0.id
  resource_id   = aws_api_gateway_resource.hello.0.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello" {
  count                   = local.rest_api_callback
  rest_api_id             = aws_api_gateway_rest_api.grant.0.id
  resource_id             = aws_api_gateway_resource.hello.0.id
  http_method             = aws_api_gateway_method.hello.0.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.callback.0.invoke_arn
}

# Callback - Twitter

resource "aws_api_gateway_resource" "hi" {
  count       = local.rest_api_callback
  rest_api_id = aws_api_gateway_rest_api.grant.0.id
  parent_id   = aws_api_gateway_rest_api.grant.0.root_resource_id
  path_part   = "hi"
}

resource "aws_api_gateway_method" "hi" {
  count         = local.rest_api_callback
  rest_api_id   = aws_api_gateway_rest_api.grant.0.id
  resource_id   = aws_api_gateway_resource.hi.0.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hi" {
  count                   = local.rest_api_callback
  rest_api_id             = aws_api_gateway_rest_api.grant.0.id
  resource_id             = aws_api_gateway_resource.hi.0.id
  http_method             = aws_api_gateway_method.hi.0.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.callback.0.invoke_arn
}

# Permissions

resource "aws_lambda_permission" "rest_api_callback" {
  count         = local.rest_api_callback
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.callback.0.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.grant.0.id}/*/*/*"
}
