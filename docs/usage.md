# 사용법

```hcl
module "example" {
  source = "git::https://github.com/NHNAD-wooyeon/hyper-infra-modules.git//terraform-aws-ecr?ref=v1.0.0"
  
  # 모듈별 변수
  repository_name = "my-app"
}
```