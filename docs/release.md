# 릴리스 워크플로우

## 1. 개발
```bash
# 기능 브랜치 생성
git checkout -b feature/add-lambda-layers

# 변경사항 작업
# 테스트와 문서 작성

# 컨벤션 형식으로 커밋
git commit -m "feat: add Lambda layers support"
```

## 2. 테스팅
```bash
# 변경사항 테스트
terraform init
terraform plan
terraform apply
terraform destroy
```

## 3. 릴리스 프로세스
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

## 4. 버전 태그 예시

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