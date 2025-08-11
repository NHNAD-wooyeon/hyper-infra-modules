# 사용법

## ECR 모듈 사용 예시

```hcl
module "ecr_example" {
  source = "git::https://github.com/NHNAD-wooyeon/hyper-infra-modules.git//terraform-aws-ecr?ref=v1.0.0"
  
  # 모듈별 변수
  repository_name = "my-app"
}
```

## Lambda 모듈 사용 예시

```hcl
module "lambda_example" {
  source = "git::https://github.com/NHNAD-wooyeon/hyper-infra-modules.git//terraform-aws-lambda?ref=v1.0.0"
  
  # 모듈별 변수
  function_name = "my-function"
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"
}
```

## SQS 모듈 사용 예시

```hcl
module "sqs_example" {
  source = "git::https://github.com/NHNAD-wooyeon/hyper-infra-modules.git//terraform-aws-sqs?ref=v1.0.0"
  
  # 모듈별 변수
  name = "my-queue"
  
  tags = {
    Environment = "development"
    Project     = "example"
  }
}
```