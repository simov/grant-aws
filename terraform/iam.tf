resource "aws_iam_role" "lambda" {
  name               = var.lambda
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        }
      }
    ]
  }
  EOF
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "gateway" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.grant.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_apigatewayv2_api.grant.id}/*/*/*"
}
