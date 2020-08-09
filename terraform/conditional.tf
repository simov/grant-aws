
locals {
  enabled = (
    var.example == "transport-querystring" ||
    var.example == "transport-session"
  ) ? 1 : 0
}

# -----------------------------------------------------------------------------

# REST API Gateway

resource "aws_api_gateway_rest_api" "grant" {
  count       = local.enabled
  name        = "grant-oauth"
  description = "OAuth Simplified"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Grant

resource "aws_api_gateway_resource" "prefix" {
  count       = local.enabled
  rest_api_id = aws_api_gateway_rest_api.grant.0.id
  parent_id   = aws_api_gateway_rest_api.grant.0.root_resource_id
  path_part   = "connect"
}

resource "aws_api_gateway_resource" "grant" {
  count       = local.enabled
  rest_api_id = aws_api_gateway_rest_api.grant.0.id
  parent_id   = aws_api_gateway_resource.prefix.0.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "grant" {
  count         = local.enabled
  rest_api_id   = aws_api_gateway_rest_api.grant.0.id
  resource_id   = aws_api_gateway_resource.grant.0.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "grant" {
  count                   = local.enabled
  rest_api_id             = aws_api_gateway_rest_api.grant.0.id
  resource_id             = aws_api_gateway_resource.grant.0.id
  http_method             = aws_api_gateway_method.grant.0.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.grant.invoke_arn
}

# Google

resource "aws_api_gateway_resource" "hello" {
  count       = local.enabled
  rest_api_id = aws_api_gateway_rest_api.grant.0.id
  parent_id   = aws_api_gateway_rest_api.grant.0.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "hello" {
  count         = local.enabled
  rest_api_id   = aws_api_gateway_rest_api.grant.0.id
  resource_id   = aws_api_gateway_resource.hello.0.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello" {
  count                   = local.enabled
  rest_api_id             = aws_api_gateway_rest_api.grant.0.id
  resource_id             = aws_api_gateway_resource.hello.0.id
  http_method             = aws_api_gateway_method.hello.0.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.callback.0.invoke_arn
}

# Twitter

resource "aws_api_gateway_resource" "hi" {
  count       = local.enabled
  rest_api_id = aws_api_gateway_rest_api.grant.0.id
  parent_id   = aws_api_gateway_rest_api.grant.0.root_resource_id
  path_part   = "hi"
}

resource "aws_api_gateway_method" "hi" {
  count         = local.enabled
  rest_api_id   = aws_api_gateway_rest_api.grant.0.id
  resource_id   = aws_api_gateway_resource.hi.0.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hi" {
  count                   = local.enabled
  rest_api_id             = aws_api_gateway_rest_api.grant.0.id
  resource_id             = aws_api_gateway_resource.hi.0.id
  http_method             = aws_api_gateway_method.hi.0.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.callback.0.invoke_arn
}

# Stage

resource "aws_api_gateway_deployment" "grant" {
  count       = local.enabled
  rest_api_id = aws_api_gateway_rest_api.grant.0.id
  stage_name  = "grant"
}

# Lambda

resource "aws_lambda_function" "callback" {
  count            = local.enabled
  function_name    = "callback"
  description      = "Grant Callback"
  filename         = var.callback
  handler          = "callback.handler"
  runtime          = "nodejs12.x"
  memory_size      = 128
  timeout          = 5
  role             = aws_iam_role.lambda.arn
  source_code_hash = filebase64sha256(var.callback)
  environment {
    variables = {
      FIREBASE_PATH = var.firebase_path
      FIREBASE_AUTH = var.firebase_auth
    }
  }
}

# Permissions

resource "aws_lambda_permission" "grant" {
  count         = local.enabled
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.grant.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.grant.0.id}/*/*/*"
}

resource "aws_lambda_permission" "callback" {
  count         = local.enabled
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.callback.0.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.grant.0.id}/*/*/*"
}
