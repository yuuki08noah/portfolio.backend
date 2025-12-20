## 📌 프로젝트 소개

**"확장성과 벤더 종속성을 고려한 고성능 API 서버"**

단순히 기능을 구현하는 것을 넘어, 전체 인프라부터 백엔드 아키텍처까지 직접 설계하고 운영함으로써 풀스택 개발자로서의 역량을 증명하고자 했습니다.
Ruby on Rails (API Mode)를 기반으로 구축되었으며, **GCP (Google Cloud Platform) Serverless** 환경 위에서 트래픽에 유연하게 대응하는 오토스케일링 아키텍처를 지향합니다.

- **개발 기간**: 2024.11.20 ~ 2024.12.18
- **개발 인원**: 1인 (개인 프로젝트)

---

## 🔍 개선 사항

### 기존 코드의 문제점 및 해결 과정

| 문제점 | 개선 방법 |
|--------|----------|
| **인프라 확장의 어려움**<br>초기 AWS EC2 모놀리식 배포는 관리가 번거롭고 유휴 리소스 비용이 발생함 | **GCP Cloud Run (Serverless)**<br>트래픽이 없을 땐 0으로, 요청 시 자동으로 확장되는 오토스케일링 환경 구축 |
| **댓글 조회 성능 저하**<br>대댓글 깊이가 깊어질수록 재귀 쿼리(Recursive CTE) 호출로 인해 DB 부하가 증가함 | **Path Enumeration 적용**<br>경로 컬럼을 활용하여 단 한 번의 `LIKE` 쿼리로 하위 트리를 고속 조회하도록 최적화 |

### 주요 개선 결과

**[심화 1: i18n 데이터 모델링]**
- **구현**: `Globalize` 같은 무거운 라이브러리 대신, **Polymorphic Association**을 활용한 `Translation` 모델을 직접 설계했습니다.
- **효과**: 새로운 모델에 다국어 지원이 필요할 때 스키마 변경 없이 관계 설정만으로 확장이 가능하며, `Accept-Language` 헤더에 따라 동적으로 언어를 로드합니다.

**[심화 2: Path Enumeration (계층형 댓글)]**
- **기존**: 인접 리스트 방식은 N+1 문제 조회가 빈번함.
- **개선**: 각 댓글에 `1/5/12`와 같은 경로 문자열을 저장. `WHERE path LIKE '1/5/%'` 쿼리 실행 시 인덱스를 타게 하여 조회 속도를 획기적으로 개선했습니다.

---

## ✨ 주요 기능

### 1. RESTful API

- **Auth**: JWT 기반 로그인/회원가입, 이메일 인증
- **Portfolio**: 프로젝트, 마일스톤, 연혁 관리
- **Blog**: 게시글, 태그, 카테고리 관리

### 2. 보안 및 인증

- **Workload Identity Federation**: GitHub Actions 배포 시 장기 키(JSON Key) 없이 OIDC로 인증하여 보안 강화
- **Rate Limiting**: 과도한 요청 방지 (Rack Attack 등 고려)

### 3. 인프라

- **Storage**: Google Cloud Storage(GCS)를 이용한 미디어 자산 관리
- **CI/CD**: GitHub Actions를 통한 자동화된 테스트 및 배포 파이프라인

---

## 🛠️ 기술 스택

### Backend

- **Framework**: Ruby on Rails 8.1.1 (API Mode)
- **Language**: Ruby 3.x
- **Database**: PostgreSQL 14+
- **Auth**: JWT (JSON Web Token)

### Deployment

- **Cloud**: GCP Cloud Run, Cloud SQL, GCS
- **IaC**: Terraform (Infrastructure as Code)

---

## 📂 프로젝트 구조

```
backend/
├── app/
│   ├── controllers/    # API V1 네임스페이스 컨트롤러
│   ├── models/         # 도메인 모델 & Concerns (Translatable 등)
│   ├── views/          # Jbuilder 템플릿 (JSON 응답 구조)
│   └── services/       # 비즈니스 로직 (복잡한 연산 처리)
├── config/             # Routes 및 초기 설정
└── db/                 # 마이그레이션 파일
```

---

## 🔗 API 명세

### 1. Authentication (인증)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/login` | 로그인 (Access Token 발급) |
| POST | `/api/v1/auth/register` | 회원가입 |

### 2. Portfolio & Blog

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/projects` | 프로젝트 목록 조회 |
| GET | `/api/v1/projects/:slug` | 프로젝트 상세 조회 |
| GET | `/api/v1/posts` | 블로그 게시글 목록 |

### 3. Reading & Travel

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/books` | 독서 기록 조회 |
| GET | `/api/v1/travel/stats` | 여행 지도 데이터 (GeoJSON) |

---

## 💻 로컬 실행 방법

### 1. 레포지토리 클론

```bash
git clone https://github.com/yuuki08noah/portfolio.backend.git
cd portfolio.backend
```

### 2. 의존성 설치

```bash
bundle install
```

### 3. 데이터베이스 설정

`.env` 파일 설정 후:

```bash
rails db:create
rails db:migrate
rails db:seed
```

### 4. 서버 실행

```bash
rails s -p 3000
```

---

## 🎥 시연 영상

[YouTube 링크](https://youtu.be/9HfOZwA1XUI)

---

## 📚 참고 자료

- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [Google Cloud Run Docs](https://cloud.google.com/run/docs)
