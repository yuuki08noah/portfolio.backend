# Portfolio Backend (Rails API)

포트폴리오 및 블로그 서비스를 위한 RESTful API 서버입니다.
Ruby on Rails (API Mode)를 기반으로 구축되었으며, GCP (Google Cloud Platform) 인프라 위에서 확장성 있는 아키텍처를 지향합니다.

## 🚀 진단 및 개선 목표

### 1. 나만의 차별화된 플랫폼 구축

시중에는 이미 훌륭한 블로그 서비스가 많지만, 개발자로서의 독창성을 표현하기에는 커스터마이징의 한계가 명확했습니다.
단순히 기능을 구현하는 것을 넘어, 전체 인프라부터 백엔드 아키텍처까지 직접 설계하고 운영함으로써 풀스택 개발자로서의 역량을 증명하고 나만의 아이덴티티가 담긴 서비스를 만들고자 했습니다.

### 2. 인프라 확장성 및 벤더 종속성 해결

초기 AWS EC2/S3 기반의 모놀리식 배포 방식은 관리가 번거롭고 비용 효율적이지 못했습니다.
이를 해결하기 위해 GCP Cloud Run (Serverless)으로 마이그레이션하여 트래픽에 따라 자동으로 인스턴스가 조절되는 오토스케일링 환경을 구축했습니다. 또한 파일 스토리지는 Google Cloud Storage (GCS)로 전환하여 안정적인 미디어 서빙 환경을 마련했습니다.

---

## 💡 적용 기술 심화 설명: i18n & Path Enumeration

### 1. 확장성 있는 다국어(i18n) 데이터 설계

Globalize와 같은 무거운 젬을 사용하지 않고, 직접 Translation 모델을 Polymorphic Association으로 설계하여 경량화된 다국어 시스템을 구축했습니다.
각 번역 데이터는 translations 테이블에 key, locale, translatable_type, translatable_id 컬럼으로 관리됩니다. 이 방식 덕분에 새로운 모델에 다국어 지원이 필요할 때마다 별도의 테이블을 생성할 필요 없이, 단순히 모델에 관계 설정만 추가하면 되어 유지보수성과 확장성이 매우 뛰어납니다. 요청 헤더의 Accept-Language 값을 기반으로 자동으로 적절한 언어 데이터를 로드하도록 구현했습니다.

### 2. 고성능 계층형 댓글 시스템 (Path Enumeration)

일반적인 인접 리스트(Adjacency List) 방식은 댓글의 깊이가 깊어질수록 재귀 쿼리(Recursive CTE)를 사용해야 하므로 성능 저하가 발생합니다.
이를 해결하기 위해 Path Enumeration 패턴을 적용했습니다. 각 댓글에 상위 댓글들의 ID를 경로 문자열(예: 1/5/12)로 저장합니다. 이를 통해 특정 댓글의 모든 하위 대댓글을 조회할 때 LIKE '1/5/%' 쿼리 단 한 번으로 가져올 수 있어, 읽기 성능을 획기적으로 개선했습니다. 쓰기 작업 시 경로 생성 오버헤드가 있으나, 댓글 시스템 특성상 읽기 비중이 압도적으로 높기에 적합한 선택이었습니다.

---

## 📡 API 명세 상세

### 1. Authentication (인증)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/v1/auth/login | 이메일/비밀번호로 로그인 (JWT 발급) |
| POST | /api/v1/auth/register | 회원가입 |
| POST | /api/v1/auth/verify_email | 이메일 인증 확인 |
| GET  | /api/v1/users/me | 현재 로그인한 내 정보 조회 |

### 2. Portfolio (포트폴리오)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET  | /api/v1/portfolio/profile | 프로필 및 자기소개 조회 |
| GET  | /api/v1/portfolio/projects | 프로젝트 목록 조회 (필터링 지원) |
| GET  | /api/v1/portfolio/projects/:slug | 프로젝트 상세 조회 |
| POST | /api/v1/portfolio/projects | [Admin] 프로젝트 생성 |
| PATCH| /api/v1/portfolio/projects/:slug | [Admin] 프로젝트 수정 |
| GET  | /api/v1/portfolio/milestones | 타임라인(연혁) 조회 |

### 3. Blog (블로그)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET  | /api/v1/blog/posts | 게시글 목록 조회 (검색, 태그 필터) |
| GET  | /api/v1/blog/posts/:slug | 게시글 상세 조회 |
| POST | /api/v1/blog/posts | [Admin] 게시글 작성 |
| GET  | /api/v1/blog/categories | 카테고리 목록 조회 |
| GET  | /api/v1/blog/tags | 태그 클라우드 데이터 조회 |

### 4. Reading (독서)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET  | /api/v1/reading/books | 읽은/읽고 있는 도서 목록 |
| POST | /api/v1/reading/books | [Admin] 도서 기록 추가 |
| GET  | /api/v1/reading/stats | 연도별 독서 통계 및 장르 분석 |

### 5. Travel (여행)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET  | /api/v1/travel/diaries | 여행 일지 목록 |
| GET  | /api/v1/travel/plans | 여행 계획 목록 |
| GET  | /api/v1/travel/stats | 방문 국가 지도 데이터 (GeoJSON) |

### 6. Admin & Utility

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET  | /api/v1/admin/accounts | [SuerAdmin] 계정 관리 |
| POST | /api/v1/uploads | 이미지 업로드 (GCS) |
| GET  | /api/v1/site_settings | 전체 사이트 설정 (SEO, 메타데이터) |

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

.env 파일 설정 후:

```bash
rails db:create
rails db:migrate
rails db:seed # 초기 데이터 로드
```

### 4. 실행

```bash
rails s -p 3000
```

서버가 <http://localhost:3000에서> 실행됩니다.
