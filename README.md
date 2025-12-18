# Portfolio (Backend)

> **배포 URL**: <https://portfolio-yuuki08noah-447543468752.asia-northeast3.run.app> (예시)
> **테스트 계정**: ID: `admin@example.com` / PW: (App log 확인 필요)

## 📌 프로젝트 소개

포트폴리오 및 블로그 서비스를 위한 고성능 RESTful API 서버입니다. Rails API 모드로 구축되었으며, GCP 기반의 서버리스 아키텍처를 채택하여 확장성을 확보했습니다.

- **개발 기간**: 2024.11.20 ~ 2024.12.18
- **개발 인원**: 1인 (개인 프로젝트)

---

## 🔍 개선 사항

### 기존 코드의 문제점

| 문제점 | 개선 방법 |
|--------|----------|
| 딥 뎁스 댓글 조회 시 N+1 문제 | Path Enumeration 패턴 적용 |
| 하드코딩된 다국어 지원의 한계 | Polymorphic Association 기반 DB 다국어 설계 |

### 개선 결과

**[개선 1: Path Enumeration (계층형 댓글)]**

- **개선 전**: 대댓글 깊이가 깊어질수록 재귀 쿼리 호출이 늘어나 성능 저하 발생
- **개선 후**: 경로 컬럼(예: `1/5/12`)을 통해 `LIKE` 쿼리 한 번으로 모든 하위 댓글 고속 조회

---

## ✨ 주요 기능

### 1. API 서버

- RESTful 원칙을 준수한 리소스 설계
- JWT 기반 Stateless 인증

### 2. 성능 최적화

- [선택한 심화 기술: Path Enumeration 댓글 시스템]
- [선택한 심화 기술: Polymorphic i18n 시스템]

### 3. 인프라

- Workload Identity Federation을 통한 Keyless 배포
- Cloud Storage(GCS) 연동을 통한 미디어 서빙

---

## 🛠️ 기술 스택

### Backend

- Ruby 3.x
- Rails 8.1.1
- PostgreSQL
- JWT

### Deployment

- GCP Cloud Run
- Google Cloud Storage (GCS)
- GitHub Actions (CI/CD)

---

## 📂 프로젝트 구조

```
backend/
├── app/
│   ├── controllers/
│   │   └── api/v1/     # 버전 관리된 API 컨트롤러
│   ├── models/         # 도메인 모델 (Comment, Project 등)
│   └── services/       # 비즈니스 로직 처리
├── config/
│   └── routes.rb       # API 라우팅 정의
└── db/                 # 스키마 및 마이그레이션
```

---

## 🔗 API 명세

### 인증

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/register` | 회원가입 |
| POST | `/api/v1/auth/login` | 로그인 |

### 포트폴리오

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/portfolio/projects` | 프로젝트 목록 조회 |
| GET | `/api/v1/portfolio/projects/:slug` | 프로젝트 상세 조회 |
| POST | `/api/v1/portfolio/projects` | [Admin] 프로젝트 생성 |

### 게시글 & 댓글

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/blog/posts` | 게시글 목록 조회 |
| GET | `/api/v1/comments` | 댓글 목록 조회 (Path Enumeration) |
| POST | `/api/v1/comments` | 댓글 작성 |

---

## 💻 로컬 실행 방법

### 1. 레포지토리 클론

```bash
git clone https://github.com/yuuki08noah/portfolio.backend.git
cd portfolio.backend
```

### 2. 백엔드 실행

```bash
bundle install

# .env 설정 (DB 접속 정보 등)
# DATABASE_URL=postgres://user:pass@localhost:5432/portfolio_dev

rails db:create db:migrate db:seed
rails s -p 3000
```

---

## 🎥 시연 영상

[YouTube 링크](https://youtu.be/9HfOZwA1XUI)

---

## 📚 참고 자료

- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [Google Cloud Run Documentation](https://cloud.google.com/run/docs)
