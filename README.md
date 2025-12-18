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

## 💡 적용 기술 심화 설명: i18n & Path Enumeration

### 1. 글로벌 서비스 대응을 위한 i18n

DB 기반의 다국어 번역 시스템을 구축하여 클라이언트 요청 언어(`Accept-Language`)에 따라 동적으로 콘텐츠를 제공합니다.

- **구현 방식**: `Globalize` 젬을 활용하지 않고, 별도의 `Translation` 모델(Polymorphic Association)을 설계하여 유연성을 확보했습니다.
- **이점**: 새로운 언어 추가 시 스키마 변경 없이 데이터 레벨에서 즉시 확장이 가능합니다.

### 2. 고성능 계층형 댓글 시스템 (Path Enumeration)

댓글/대댓글 구조를 효율적으로 처리하기 위해 **Path Enumeration** 패턴을 적용했습니다.

- **기존 문제**: 인접 리스트(Adjacency List) 방식은 깊은 뎁스의 대댓글 조회 시 N+1 문제와 재귀 쿼리 비용이 발생합니다.
- **해결**: 각 댓글에 전체 경로(path)를 저장(예: `1/5/12`)하여, `LIKE '1/5/%'` 쿼리 한 번으로 하위 트리를 고속 조회할 수 있게 최적화했습니다.

---

## 📡 API 명세 상세

### 1. Authentication (인증)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/v1/auth/login` | 이메일/비밀번호로 로그인 (JWT 발급) |
| `POST` | `/api/v1/auth/register` | 회원가입 |
| `POST` | `/api/v1/auth/verify_email` | 이메일 인증 확인 |
| `GET`  | `/api/v1/users/me` | 현재 로그인한 내 정보 조회 |

### 2. Portfolio (포트폴리오)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET`  | `/api/v1/portfolio/profile` | 프로필 및 자기소개 조회 |
| `GET`  | `/api/v1/portfolio/projects` | 프로젝트 목록 조회 (필터링 지원) |
| `GET`  | `/api/v1/portfolio/projects/:slug` | 프로젝트 상세 조회 |
| `POST` | `/api/v1/portfolio/projects` | [Admin] 프로젝트 생성 |
| `PATCH`| `/api/v1/portfolio/projects/:slug` | [Admin] 프로젝트 수정 |
| `GET`  | `/api/v1/portfolio/milestones` | 타임라인(연혁) 조회 |

### 3. Blog (블로그)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET`  | `/api/v1/blog/posts` | 게시글 목록 조회 (검색, 태그 필터) |
| `GET`  | `/api/v1/blog/posts/:slug` | 게시글 상세 조회 |
| `POST` | `/api/v1/blog/posts` | [Admin] 게시글 작성 |
| `GET`  | `/api/v1/blog/categories` | 카테고리 목록 조회 |
| `GET`  | `/api/v1/blog/tags` | 태그 클라우드 데이터 조회 |

### 4. Reading (독서)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET`  | `/api/v1/reading/books` | 읽은/읽고 있는 도서 목록 |
| `POST` | `/api/v1/reading/books` | [Admin] 도서 기록 추가 |
| `GET`  | `/api/v1/reading/stats` | 연도별 독서 통계 및 장르 분석 |

### 5. Travel (여행)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET`  | `/api/v1/travel/diaries` | 여행 일지 목록 |
| `GET`  | `/api/v1/travel/plans` | 여행 계획 목록 |
| `GET`  | `/api/v1/travel/stats` | 방문 국가 지도 데이터 (GeoJSON) |

### 6. Admin & Utility

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET`  | `/api/v1/admin/accounts` | [SuerAdmin] 계정 관리 |
| `POST` | `/api/v1/uploads` | 이미지 업로드 (GCS) |
| `GET`  | `/api/v1/site_settings` | 전체 사이트 설정 (SEO, 메타데이터) |

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
