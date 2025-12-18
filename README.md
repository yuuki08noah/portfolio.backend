# Portfolio Backend (Rails API)

포트폴리오 및 블로그 서비스를 위한 RESTful API 서버입니다.
**Ruby on Rails (API Mode)**를 기반으로 구축되었으며, **GCP (Google Cloud Platform)** 인프라 위에서 확장성 있는 아키텍처를 지향합니다.

## 🚀 진단 및 개선 목표

### 1. 인프라 확장성 및 벤더 종속성 해결

- **진단**: 초기 AWS EC2/S3 기반의 모놀리식 배포 방식은 관리가 번거롭고 비용 효율적이지 못했습니다. 또한 로컬 파일 시스템에 의존하는 업로드 방식은 확장이 불가능했습니다.
- **개선**: **GCP Cloud Run (Serverless)**으로 마이그레이션하여 오토스케일링과 무중단 배포를 실현했습니다. 파일 스토리지는 **Google Cloud Storage (GCS)**로 전환하여 안정적인 미디어 서빙 환경을 구축했습니다.

### 2. API 구조의 파편화 방지

- **진단**: 기능이 추가됨에 따라 컨트롤러가 비대해지고, 도메인 간의 경계가 모호해지는 문제가 있었습니다.
- **개선**: **Namespaced Controllers (`Api::V1::Domain`)** 구조를 도입하여 API 버전을 관리하고, 도메인별(Portfolio, Blog, Tech, Travel)로 명확히 모듈화하여 유지보수성을 대폭 향상시켰습니다.

---

## 💡 적용 기술 심화 설명: Workload Identity Federation & GCP Integration

보안 강화를 위해 장기(Long-lived) 서비스 키(JSON Key)를 사용하는 대신 **Workload Identity Federation**을 도입했습니다.

### 구현 근거

CI/CD 파이프라인(GitHub Actions)에서 GCP 리소스에 접근하기 위해 서비스 계정 키를 저장소 Secrets에 저장하는 것은 보안 리스크가 큽니다. 키 유출 시 치명적인 사고로 이어질 수 있기 때문입니다.

### 기술적 이점

- **Keyless Security**: 서비스 계정 키를 생성하거나 관리할 필요 없이, GitHub의 OIDC 토큰을 사용하여 임시 권한을 획득합니다.
- **최소 권한 원칙**: 배포에 필요한 권한(`roles/run.admin`, `roles/storage.admin`)만 최소한으로 부여하여 보안 사고의 반경을 최소화합니다.
- **자동화된 인프라 관리**: Terraform과 연동하여 IAM 정책을 코드로 관리(IaC)함으로써 보안 설정의 일관성을 유지합니다.

---

## 📡 API 명세 요약

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/v1/portfolio/projects` | 프로젝트 전체 목록 조회 |
| `POST` | `/api/v1/portfolio/projects` | [Admin] 새 프로젝트 생성 |
| `GET` | `/api/v1/blog/posts` | 블로그 글 목록 조회 (검색/필터링) |
| `POST` | `/api/v1/uploads` | 이미지 업로드 (GCS URL 반환) |
| `GET` | `/api/v1/reading/books` | 읽은 도서 목록 및 상태 조회 |
| `GET` | `/api/v1/travel/map` | 여행 지도 데이터 (GeoJSON) |

---

## 🏃 로컬 실행 방법

### 1. 사전 요구 사항

- Ruby (v3.2+)
- PostgreSQL (v14+)
- Rails (v7+)

### 2. 프로젝트 클론 및 설치

```bash
git clone https://github.com/yuuki08noah/portfolio.backend.git
cd portfolio.backend
bundle install
```

### 3. 데이터베이스 설정

`.env` 파일 설정 후:

```bash
rails db:create
rails db:migrate
rails db:seed # 초기 데이터 로드
```

### 4. 실행

```bash
rails s -p 3000
```

서버가 `http://localhost:3000`에서 실행됩니다.
