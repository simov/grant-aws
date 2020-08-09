
resource "aws_apigatewayv2_api" "grant" {
  name          = "grant-oauth"
  description   = "OAuth Simplified"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "proxy" {
  api_id             = aws_apigatewayv2_api.grant.id
  description        = "Grant OAuth Proxy"
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.grant.invoke_arn
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

resource "aws_apigatewayv2_stage" "grant" {
  api_id      = aws_apigatewayv2_api.grant.id
  name        = "grant"
  auto_deploy = true
}
