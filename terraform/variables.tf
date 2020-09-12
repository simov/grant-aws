
variable "grant" {}
variable "callback" {}
variable "lambda" {}
variable "region" {}
variable "api_type" {}
variable "event_format" {}
variable "example" {}
variable "firebase_path" {}
variable "firebase_auth" {}

# -----------------------------------------------------------------------------

data "aws_caller_identity" "current" {}

locals {
  rest_api = var.api_type == "rest-api" ? 1 : 0

  callback = (
    var.example == "transport-querystring" ||
    var.example == "transport-session"
  ) ? 1 : 0

  rest_api_callback = (
    local.rest_api == 1 &&
    local.callback == 1
  ) ? 1 : 0
}
