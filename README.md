# 🩸 야수의 심장: The Execution — 피의 서약 챌린지 플랫폼

> **작심삼일을 이겨내는 방법 — 보증금을 걸고, 매일 인증하고, 실패하면 소각된다.**

---

## 📌 프로젝트 소개

**야수의 심장: The Execution**은 자기 자신과의 계약을 강제하는 챌린지 플랫폼입니다.

단순한 목표 설정 앱이 아닙니다. 사용자는 챌린지를 시작할 때 **보증금**을 걸고, 매일 사진으로 인증해야 합니다. 인증에 실패하면 보증금이 소각됩니다. 이 구조가 진짜 동기부여를 만듭니다.

소각의 방식은 본인이 정할 수 있습니다. 현재 준비된 방법은 사회 기부(기관 본인이 설정 가능)하게 하는 방식 / 앱 내 크레딧으로 전환하여 재계약 시 사용 가능하게 설정할 수 있도록 하는 방식(최초 1회)입니다.

본인이 선택한 계약 챌린지를 성공적으로 완수 시, 본인이 걸었던 보증금의 전액을 돌려받고, 제휴사 혜택을 받습니다. 추후, 앱 내 커뮤니티를 만들어 뱃지 인증 및 명예의 전당에 올라 승부욕을 자극하는 컨텐츠로의 확장을 기대해볼 수 있습니다.

```
서약 → 보증금 잠금 → 매일 인증 → AI 판정 → 성공 시 반환 / 실패 시 소각
```

---

## 🛠 기술 스택

| 영역 | 기술 |
|---|---|
| **Frontend** | Flutter (Web / Android / iOS) |
| **Backend** | NestJS (TypeScript) |
| **Database** | PostgreSQL |
| **인프라** | Docker, Docker Compose |
| **상태 관리** | Riverpod (Flutter) |
| **라우팅** | GoRouter (Flutter) |
| **HTTP 클라이언트** | Dio (Flutter) |

---

## ✨ 주요 기능 (MVP)

- 🔐 **Mock OAuth 로그인** (Google / Kakao)
- 📝 **피의 서약** — 챌린지 계약 생성 및 관리 (복수 서약 동시 진행 가능)
- 📅 **기간 선택** — 3일 / 1주일 / 2주 / 3주 / 한 달 / 2달 / 3달
- 🔥 **소각 방식 선택** — 완전 소각 / 사회 기부 (5개 기관) / 앱 크레딧 전환 (최초 1회)
- 💰 **보증금 잠금** — 챌린지 활성화 시 보증금 스마트 금고에 잠금
- 📸 **사진 인증** — 매일 미션 사진 업로드
- ⚖️ **자동 판정** — 인증 결과 PASS / FAIL 처리
- 📋 **오늘의 챌린지 현황** — 오늘 아직 인증하지 않은 챌린지 목록
- 📖 **서비스 설명 페이지** — 스크롤 애니메이션 기반 서비스 소개
- 🔗 **단계별 상세 설명 페이지** — 서약·잠금·인증·정산 각 단계를 클릭하면 상세 페이지로 이동

---

## 🗂 프로젝트 구조

```
Beast Heart MVP/
├── backend/                # NestJS 백엔드
│   ├── src/
│   │   ├── user/           # 유저 모듈 (credits, credit_used 포함)
│   │   ├── challenge/      # 챌린지 & 보증금 모듈
│   │   ├── mission/        # 미션 생성 모듈
│   │   ├── attempt/        # 인증 제출 모듈
│   │   └── settlement/     # 정산 모듈
│   ├── .env.example        # 환경 변수 예시
│   └── Dockerfile
├── frontend/               # Flutter 프론트엔드
│   └── lib/
│       ├── core/           # 라우터, 테마, 네트워크
│       └── features/
│           ├── auth/       # 로그인
│           ├── landing/    # 메인 홈페이지
│           ├── about/      # 서비스 설명 페이지
│           │   └── detail/ # 단계별 상세 설명 페이지 (서약/잠금/인증/정산)
│           ├── oath/       # 피의 서약 (계약 관리)
│           ├── home/       # 오늘의 챌린지 현황
│           ├── challenge/  # 챌린지 생성
│           ├── camera/     # 미션 인증
│           ├── mission/    # 미션 모델
│           └── attempt/    # 인증 제출
└── docker-compose.yml      # DB 컨테이너 설정
```

---

## 🚀 로컬 실행 방법

### 1. 사전 준비

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) 설치
- [Node.js 18+](https://nodejs.org/) 설치
- [Flutter SDK](https://flutter.dev/docs/get-started/install) 설치

### 2. 데이터베이스 실행

```bash
docker-compose up -d
```

### 3. 백엔드 실행

```bash
cd backend

# 환경 변수 설정
cp .env.example .env
# .env 파일을 열어 DB 정보 확인 (기본값으로 바로 실행 가능)

# 의존성 설치 및 실행
npm install
npm run start:dev
```

백엔드가 `http://localhost:3000`에서 실행됩니다.

### 4. 프론트엔드 실행

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

---

## 🌐 API 엔드포인트 (주요)

| Method | Path | 설명 |
|---|---|---|
| `POST` | `/users/login` | 로그인 / 회원가입 |
| `GET` | `/challenges?user_id=` | 챌린지 목록 조회 (전체) |
| `POST` | `/challenges` | 챌린지 생성 (`failure_rule`, `donate_target`, `duration_days` 포함) |
| `POST` | `/challenges/:id/activate` | 챌린지 활성화 (`amount`, `duration_days` 전달) |
| `GET` | `/missions/today?challenge_id=` | 오늘의 미션 조회 |
| `POST` | `/attempts` | 인증 사진 제출 |
| `GET` | `/attempts?user_id=` | 인증 내역 조회 |

---

## 🗺 화면 구성

```
/auth                → 로그인 화면
/                    → 메인 랜딩 페이지
/about               → 서비스 설명 페이지 (스크롤 애니메이션)
/about/oath          → [상세] 서약 단계 설명
/about/lock          → [상세] 보증금 잠금 단계 설명
/about/verify        → [상세] 매일 인증 단계 설명
/about/settlement    → [상세] 정산 단계 설명
/oath                → 피의 서약 (전체 챌린지 계약 목록)
/dashboard           → 오늘의 챌린지 현황 (미인증 챌린지 목록)
/challenge/create    → 새 챌린지 생성 (기간·소각방식 선택)
/camera              → 미션 인증 사진 촬영
```

### 화면 간 연결 흐름

```
메인 랜딩 (/)
  ├── 서약/잠금/인증/정산 카드 클릭 → 각 상세 설명 페이지 (/about/oath 등)
  │     └── 상세 페이지 내 이전/다음 버튼으로 단계 간 이동
  │           └── 마지막 단계(정산)에서 "피의 서약 맺기" CTA → /auth
  ├── 자세히 알아보기 → /about (전체 서비스 소개)
  │     └── 작동 방식 섹션 카드 클릭 → 각 상세 설명 페이지
  └── 피의 서약 카드 → /oath (계약 관리)
```

---

## 📋 챌린지 종류

| 코드 | 이름 |
|---|---|
| `wakeup` | 🌅 기상 챌린지 |
| `commit` | 💻 커밋 챌린지 |
| `gym` | 🏋️ 헬스 챌린지 |
| `study` | 📚 공부 챌린지 |
| `running` | 🏃 러닝 챌린지 |

---

## 🔥 소각 방식

| 방식 | 설명 | 제한 |
|---|---|---|
| `BURN` | 보증금 완전 소각 | 없음 |
| `DONATE` | 선택 기관에 기부 | 없음 |
| `CREDIT` | 앱 내 크레딧으로 전환 | **평생 1회** |

### 기부 가능 기관

유니세프 / 그린피스 / 세이브더칠드런 / WWF(세계자연기금) / 대한적십자사

---

## 📅 챌린지 기간 옵션

`3일` / `1주일` / `2주` / `3주` / `한 달` / `2달` / `3달`

---

## ⚠️ 주의사항

- 현재 버전은 **MVP**입니다. 실제 결제 연동은 포함되지 않습니다.
- OAuth 로그인은 테스트용 Mock으로 구현되어 있습니다.
- AI 판정 기능은 추후 연동 예정입니다.
- 미션은 백엔드에서 수동으로 생성해야 합니다 (자동 생성 미구현).

---

## 📄 라이선스

MIT License
