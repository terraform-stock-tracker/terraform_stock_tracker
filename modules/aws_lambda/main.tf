#################################################################
######### Lambda Packaging ######################################
#################################################################
locals {
  lambda_bundle_path = "${var.root_path}/.tmp"
}

# Compute the source code hash, only taking into
# consideration the actual application code files
# and the dependencies list.
resource "random_uuid" "lambda_src_hash" {
  keepers = {
  for filename in setunion(
    fileset(var.lambda_path, "*.py"),
    fileset(var.lambda_path, "requirements.txt"),
    fileset(var.lambda_path, "src/*.py")
  ):
  filename => filemd5("${var.lambda_path}/${filename}")
  }
}


# Create temporary folder for where all the dependencies will be stored into
# Copy all the files from the lambda path into this folder.
resource "null_resource" "make_bundle_folder" {
  provisioner "local-exec" {
    command = "mkdir -p ${local.lambda_bundle_path} && cp -r ${var.lambda_path}/* ${local.lambda_bundle_path}"
  }
  triggers = {
    source_code_hash = random_uuid.lambda_src_hash.result
  }
}

# Automatically install dependencies to be packaged
resource "null_resource" "install_dependencies" {
  provisioner "local-exec" {
    command = "pip install -r ${var.lambda_path}/requirements.txt -t ${local.lambda_bundle_path}"
  }

  # Only re-run this if the dependencies or their versions
  # have changed since the last deployment with Terraform
  triggers = {
    source_code_hash = random_uuid.lambda_src_hash.result
  }
}

# Create an archive form the Lambda source code,
# filtering out unneeded files.
data "archive_file" "lambda_source_package" {
  type        = "zip"
  source_dir  = local.lambda_bundle_path
  output_path = "${path.module}/.tmp/${random_uuid.lambda_src_hash.result}.zip"

  excludes    = [
    "__pycache__",
    "src/__pycache__",
    "tests"
  ]

  # This is necessary, since archive_file is now a
  # `data` source and not a `resource` anymore.
  # Use `depends_on` to wait for the "install dependencies"
  # task to be completed.
  depends_on = [null_resource.install_dependencies]
}

#################################################################
######### Lambda IAM ROLE #######################################
#################################################################

resource "aws_iam_role" "lambda_iam" {
  name = "iam_for_lambda"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags              = var.tags
}


#################################################################
######### Lambda Function #######################################
#################################################################

resource "aws_lambda_function" "lambda_function" {
  filename          = data.archive_file.lambda_source_package.output_path
  function_name     = var.lambda_name
  role              = aws_iam_role.lambda_iam.arn
  handler           = "function.lambda_handler"

  source_code_hash  = data.archive_file.lambda_source_package.output_base64sha256
  memory_size       = var.memory_size
  runtime           = var.lambda_runtime
  timeout           = var.timeout

  environment {
    variables = var.env_vars
  }

  tags              = var.tags
}

#################################################################
######### Cloudwatch Logs #######################################
#################################################################

# Create a log group and specify the retention period
resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = var.log_retention_days
  lifecycle {
    prevent_destroy = false
  }
  tags              = var.tags
}

# Create a logging policy
resource "aws_iam_policy" "function_logging_policy" {
  name   = "function-logging-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Attach the logging policy to the function role to the IAM Role
resource "aws_iam_role_policy_attachment" "function_logging_policy_attachment" {
  role                = aws_iam_role.lambda_iam.id
  policy_arn          = aws_iam_policy.function_logging_policy.arn
}
