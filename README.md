# Hyper Infrastructure Modules

AWS 인프라 구성요소를 위한 재사용 가능한 Terraform 모듈 모음입니다.

## 사용 가능한 모듈

| 모듈 | 설명 | 최신 버전 |
|--------|-------------|----------------|
| [terraform-aws-ecr](./terraform-aws-ecr/) | AWS Elastic Container Registry | v1.0.0 |
| [terraform-aws-lambda](./terraform-aws-lambda/) | AWS Lambda Functions | v1.0.0 |

## 사용법

```hcl
module "example" {
  source = "git::https://github.com/hyper/hyper-infra-modules.git//terraform-aws-ecr?ref=v1.0.0"
  
  # 모듈별 변수
  repository_name = "my-app"
}
```

## 버전 관리 표준

이 저장소는 모든 모듈 릴리스에 대해 [시맨틱 버저닝](https://semver.org/) (SemVer)을 따릅니다.

### 버전 형식: `vMAJOR.MINOR.PATCH`

#### MAJOR 버전 (`v2.0.0`)
**언제 증가시킬까:** 사용자의 작업이 필요한 호환성을 깨는 변경사항

**예시:**
- 입력 변수 제거 또는 이름 변경
- 필수 프로바이더 버전의 큰 변경
- 리소스 또는 출력값 제거
- 기존 인프라를 깨뜨릴 수 있는 기본 동작 변경

**예시 시나리오:**
```hcl
# v1.x.x - 기존 변수명
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

# v2.0.0 - 호환성을 깨는 변경: 변수명 변경
variable "repository_name" {  # ← 호환성을 깨는 변경
  description = "Name of the ECR repository" 
  type        = string
}
```

**커밋 메시지:**
```
feat!: rename bucket_name variable to repository_name

BREAKING CHANGE: The variable `bucket_name` has been renamed to `repository_name` 
to better reflect the ECR resource. Update your module calls accordingly.

Before: bucket_name = "my-app"
After:  repository_name = "my-app"
```

#### MINOR 버전 (`v1.1.0`)
**언제 증가시킬까:** 하위 호환성을 유지하는 새로운 기능

**예시:**
- 새로운 선택적 입력 변수 추가
- 새로운 출력값 추가
- 새로운 선택적 리소스 추가
- 기존 사용법을 깨뜨리지 않는 새로운 기능

**예시 시나리오:**
```hcl
# v1.0.0 - 원본 모듈

# v1.1.0 - 새로운 선택적 기능 추가
variable "enable_vulnerability_scanning" {  # ← 새로운 선택적 변수
  description = "Enable vulnerability scanning"
  type        = bool
  default     = false  # ← 안전한 기본값
}
```

**커밋 메시지:**
```
feat: add vulnerability scanning support

- Add enable_vulnerability_scanning variable
- Add vulnerability_scan_results output
- Add aws_ecr_registry_scanning_configuration resource
- Scanning is disabled by default for backward compatibility
```

#### PATCH 버전 (`v1.0.1`)
**언제 증가시킬까:** 버그 수정 및 기능적이지 않은 개선사항

**예시:**
- 기존 기능의 버그 수정
- 문서 업데이트
- 동작 변경 없는 코드 리팩토링
- 의존성 업데이트 (마이너)
- 변수 검증 개선

**예시 시나리오:**
```hcl
# v1.0.0 - 버그: 검증 누락
variable "memory_size" {
  description = "Memory size in MB"
  type        = number
  default     = 128
}

# v1.0.1 - 버그 수정: 적절한 검증 추가
variable "memory_size" {
  description = "Memory size in MB"
  type        = number
  default     = 128
  validation {  # ← 버그 수정: 누락된 검증 추가
    condition     = var.memory_size >= 128 && var.memory_size <= 10240
    error_message = "Memory size must be between 128 and 10240 MB."
  }
}
```

**커밋 메시지:**
```
fix: add memory_size validation for Lambda module

- Add validation to ensure memory_size is within AWS limits (128-10240 MB)
- Prevents runtime errors when applying invalid memory configurations
- No breaking changes to existing functionality
```

## 커밋 메시지 표준

[Conventional Commits](https://www.conventionalcommits.org/) 명세를 따릅니다.

### 형식
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### 타입

| 타입 | 설명 | 버전 영향 |
|------|-------------|----------------|
| `feat!` / `fix!` | 호환성을 깨는 변경 | MAJOR |
| `feat` | 새로운 기능 | MINOR |
| `fix` | 버그 수정 | PATCH |
| `docs` | 문서 전용 | PATCH |
| `style` | 코드 스타일 변경 | PATCH |
| `refactor` | 코드 리팩토링 | PATCH |
| `test` | 테스트 추가 | PATCH |
| `chore` | 유지보수 작업 | PATCH |

### 예시

#### 새 모듈
```
feat: add terraform-aws-lambda module

- Create Lambda function resource with IAM role
- Support ZIP, S3, and container image deployment
- Add CloudWatch logging and VPC configuration
- Include comprehensive examples and documentation
```

#### 버그 수정
```
fix: correct IAM policy for Lambda VPC execution

- Add missing VPC execution policy attachment
- Fixes Lambda timeout issues in VPC environments
- Resolves issue #123
```

#### 호환성을 깨는 변경
```
feat!: upgrade to AWS provider v5.x

BREAKING CHANGE: Minimum AWS provider version is now 5.0.
This requires Terraform >= 1.0 and may require state migration.

- Update provider constraints in versions.tf
- Remove deprecated resource attributes
- Update examples to use new provider syntax
```

#### 문서 업데이트
```
docs: update ECR module usage examples

- Add container image scanning example
- Fix typo in cross-account policy
- Update README with new output variables
```

## 릴리스 워크플로우

### 1. 개발
```bash
# 기능 브랜치 생성
git checkout -b feature/add-lambda-layers

# 변경사항 작업
# 테스트와 문서 작성

# 컨벤션 형식으로 커밋
git commit -m "feat: add Lambda layers support"
```

### 2. 테스팅
```bash
# 변경사항 테스트
terraform init
terraform plan
terraform apply
terraform destroy
```

### 3. 릴리스 프로세스
```bash
# main에 병합
git checkout main
git pull origin main

# 버전 태그 생성 및 푸시
git tag v1.1.0
git push origin v1.1.0

# 또는 호환성을 깨는 변경이 있는 메이저 릴리스
git tag v2.0.0
git push origin v2.0.0
```

### 4. 버전 태그 예시

```bash
# 첫 번째 릴리스
git tag v1.0.0

# 버그 수정
git tag v1.0.1

# 새로운 기능 (하위 호환)
git tag v1.1.0

# 호환성을 깨는 변경
git tag v2.0.0

# 여러 수정사항
git tag v1.0.2
git tag v1.0.3
```

## 라이센스

이 프로젝트는 MIT 라이센스에 따라 라이센스가 부여됩니다 - 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.