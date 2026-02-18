# 🩸 야수의 심장: The Execution — 피의 서약 챌린지 플랫폼

> **작심삼일을 이겨내는 방법 — 보증금을 걸고, 매일 인증하고, 실패하면 소각된다.**

---

## 📌 프로젝트 소개

**야수의 심장: The Execution**은 자기 자신과의 계약을 강제하는 챌린지 플랫폼입니다.

단순한 목표 설정 앱이 아닙니다. 사용자는 챌린지를 시작할 때 **보증금**을 걸고, 매일 사진으로 인증해야 합니다. 인증에 실패하면 보증금이 소각됩니다. 이 구조가 진짜 동기부여를 만듭니다.

소각의 방식은 본인이 정할 수 있습니다. 현재 준비된 방법은 사회 기부(기관 본인이 설정 가능)하게 하는 방식/ 앱 내 크레딧으로 전환하여 재계약 시 사용 가능하게 설정할 수 있도록 하는 방식(최초 1회)입니다.

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
- 📝 **피의 서약** — 챌린지 계약 생성 및 관리
- 💰 **보증금 잠금** — 챌린지 활성화 시 보증금 스마트 금고에 잠금
- 📸 **사진 인증** — 매일 미션 사진 업로드
- ⚖️ **자동 판정** — 인증 결과 PASS / FAIL 처리
- 🏠 **메인 대시보드** — 챌린지 현황, 오늘의 미션, 보증금 상태 확인

---

## 🗂 프로젝트 구조

```
Beast Heart MVP/
├── backend/                # NestJS 백엔드
│   ├── src/
│   │   ├── user/           # 유저 모듈
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
│           ├── oath/       # 피의 서약 (계약 관리)
│           ├── home/       # 대시보드
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
| `GET` | `/challenges?user_id=` | 챌린지 목록 조회 |
| `POST` | `/challenges` | 챌린지 생성 |
| `POST` | `/challenges/:id/activate` | 챌린지 활성화 (보증금 잠금) |
| `GET` | `/missions/today?challenge_id=` | 오늘의 미션 조회 |
| `POST` | `/attempts` | 인증 사진 제출 |
| `GET` | `/attempts?user_id=` | 인증 내역 조회 |

---

## 🗺 화면 구성

```
/auth         → 로그인 화면
/             → 메인 랜딩 페이지
/oath         → 피의 서약 (챌린지 계약 관리)
/dashboard    → 챌린지 대시보드
/challenge/create → 새 챌린지 생성
/camera       → 미션 인증 사진 촬영
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

## ⚠️ 주의사항

- 현재 버전은 **MVP**입니다. 실제 결제 연동은 포함되지 않습니다.
- OAuth 로그인은 테스트용 Mock으로 구현되어 있습니다.
- AI 판정 기능은 추후 연동 예정입니다.

---

## 📄 라이선스

MIT License
