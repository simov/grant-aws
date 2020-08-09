
resource "aws_lambda_function" "grant" {
  function_name    = var.lambda
  description      = "OAuth Simplified"
  filename         = var.grant
  handler          = "grant.handler"
  runtime          = "nodejs12.x"
  memory_size      = 128
  timeout          = 5
  role             = aws_iam_role.lambda.arn
  source_code_hash = filebase64sha256(var.grant)
  environment {
    variables = {
      FIREBASE_PATH = var.firebase_path
      FIREBASE_AUTH = var.firebase_auth
    }
  }
}
