# 커밋 메시지 표준

[Conventional Commits](https://www.conventionalcommits.org/) 명세를 따릅니다.

## 형식
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## 타입

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

## 예시

### 새 모듈
```
feat: add terraform-aws-lambda module

- Create Lambda function resource with IAM role
- Support ZIP, S3, and container image deployment
- Add CloudWatch logging and VPC configuration
- Include comprehensive examples and documentation
```

### 버그 수정
```
fix: correct IAM policy for Lambda VPC execution

- Add missing VPC execution policy attachment
- Fixes Lambda timeout issues in VPC environments
- Resolves issue #123
```

### 호환성을 깨는 변경
```
feat!: upgrade to AWS provider v5.x

BREAKING CHANGE: Minimum AWS provider version is now 5.0.
This requires Terraform >= 1.0 and may require state migration.

- Update provider constraints in versions.tf
- Remove deprecated resource attributes
- Update examples to use new provider syntax
```

### 문서 업데이트
```
docs: update ECR module usage examples

- Add container image scanning example
- Fix typo in cross-account policy
- Update README with new output variables
```