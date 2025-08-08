# 버전 관리 표준

이 저장소는 모든 모듈 릴리스에 대해 [시맨틱 버저닝](https://semver.org/) (SemVer)을 따릅니다.

## 버전 형식: `vMAJOR.MINOR.PATCH`

### MAJOR 버전 (`v2.0.0`)
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

### MINOR 버전 (`v1.1.0`)
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

### PATCH 버전 (`v1.0.1`)
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