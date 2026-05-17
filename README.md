# claude-agent

Discord를 통해 Claude Code를 원격으로 조작할 수 있는 Docker 기반 에이전트입니다.

## 개요

Docker 컨테이너 안에서 Claude Code를 실행하고, Discord 채널을 통해 메시지를 주고받으며 코딩 작업을 지시할 수 있습니다. 컨테이너 내부에는 Java, Node.js, Python 등 주요 개발 환경이 사전 설치되어 있습니다.

## 사전 준비

- Docker / Docker Compose
- (선택) Discord 봇 토큰 및 채널 설정 — Discord 연동을 사용할 경우에만 필요

## 디렉토리 구조

```
claude-agent/
├── Dockerfile              # 에이전트 컨테이너 이미지 정의
├── docker-compose.yml      # 컨테이너 실행 설정
├── .claude/                # Claude Code 인증 및 설정 (직접 생성)
├── .config/gh/             # GitHub CLI 인증 정보 (직접 생성)
└── workspace/              # 에이전트가 작업하는 마운트 디렉토리
    ├── CLAUDE.md           # 에이전트 행동 지침
    └── run.sh              # 컨테이너 내부에서 Claude를 실행하는 스크립트
```

## 설치 및 실행

### 1. 컨테이너 빌드 및 실행

```bash
docker compose up -d --build
```

### 2. 컨테이너 접속

```bash
docker compose exec claude-agent bash
```

### 3. 인증

컨테이너 내부에서 Claude Code와 GitHub CLI를 각각 인증합니다.

```bash
# Claude Code 인증
claude

# GitHub CLI 인증 (필요한 경우)
gh auth login
```

인증이 완료되면 `exit`으로 컨테이너 셸을 나옵니다. 이후 재기동 시에는 인증 정보가 볼륨에 유지되므로 이 단계를 반복할 필요가 없습니다.

### 4. 에이전트 시작

Discord 없이 실행:
```bash
docker compose exec claude-agent bash /workspace/run.sh
```

Discord 연동과 함께 실행:
```bash
docker compose exec claude-agent bash /workspace/run.sh --discord
```

에이전트가 tmux 세션(`claude-agent`)에서 백그라운드로 실행됩니다.

### 5. 세션 접속

```bash
docker compose exec claude-agent tmux attach -t claude-agent
```

## 컨테이너 환경

| 항목 | 버전 |
|------|------|
| Node.js | 22 |
| Java (Temurin) | 21 |
| Python | 3.x |
| Claude Code | 최신 |
| TypeScript / tsx / bun | 최신 |

그 외 `git`, `gh`, `tmux`, `ripgrep`, `fd`, `gradle` 등이 포함되어 있습니다.

## 볼륨 마운트

| 호스트 경로 | 컨테이너 경로 | 용도 |
|-------------|---------------|------|
| `./workspace` | `/workspace` | 작업 디렉토리 |
| `./.claude` | `/home/claude/.claude` | Claude 설정 |
| `./.claude/.claude.json` | `/home/claude/.claude.json` | Claude 인증 |
| `./.config/gh` | `/home/claude/.config/gh` | GitHub CLI 인증 |
