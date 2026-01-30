# 개인용 n8n + OpenCode + Moltbot 통합 설치 가이드

이 가이드는 개인 노트북에서 n8n 워크플로우 자동화, OpenCode AI 코딩 도우미, Moltbot AI 어시스턴트를 Docker로 쉽게 설치하고 실행하는 방법을 안내합니다.

## 📋 목차

- [사전 준비](#사전-준비)
- [Docker 설치](#docker-설치)
  - [Windows 사용자](#windows-사용자)
  - [macOS 사용자](#macos-사용자)
- [n8n + OpenCode + Moltbot 설치](#n8n--opencode--moltbot-설치)
- [서비스 접속](#서비스-접속)
- [사용 예제](#사용-예제)
- [문제 해결](#문제-해결)

---

## 🎯 사전 준비

### 시스템 요구사항

- **운영체제**: Windows 10/11 (Pro, Enterprise, Education) 또는 macOS 10.15 이상
- **RAM**: 최소 8GB (권장 16GB)
- **디스크 공간**: 최소 10GB 여유 공간
- **CPU**: 64비트 프로세서

### 설치할 서비스

| 서비스 | 용도 | 포트 |
|--------|------|------|
| **n8n** | 워크플로우 자동화 플랫폼 | 5678 |
| **OpenCode** | AI 코딩 어시스턴트 | 8181 |
| **Moltbot** | AI 개인 비서 | 18789 |
| **PostgreSQL** | n8n 데이터베이스 | 5432 (내부) |

---

## 🐳 Docker 설치

Docker는 컨테이너 기반 가상화 플랫폼으로, 이 프로젝트의 모든 서비스를 실행하는 데 필요합니다.

### Windows 사용자

#### 1. 시스템 요구사항 확인

- Windows 10 64-bit: Pro, Enterprise, Education (Build 19041 이상)
- Windows 11 64-bit: Home, Pro, Enterprise, Education

#### 2. WSL2 활성화 (필수)

PowerShell을 **관리자 권한**으로 실행한 후 다음 명령어를 입력합니다:

```powershell
# WSL 활성화
wsl --install

# 컴퓨터 재시작
Restart-Computer
```

재시작 후 Ubuntu가 자동으로 설치됩니다. 사용자 이름과 비밀번호를 설정하세요.

#### 3. Docker Desktop 설치

1. [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/) 다운로드
2. 다운로드한 `Docker Desktop Installer.exe` 실행
3. 설치 중 "Use WSL 2 instead of Hyper-V" 옵션 선택
4. 설치 완료 후 컴퓨터 재시작
5. Docker Desktop 실행

#### 4. 설치 확인

PowerShell 또는 명령 프롬프트에서 확인:

```powershell
docker --version
docker compose version
```

정상 출력 예시:
```
Docker version 25.0.0, build 12345abc
Docker Compose version v2.24.0
```

---

### macOS 사용자

#### 1. 시스템 확인

터미널에서 Mac의 칩셋을 확인합니다:

```bash
uname -m
```

- `x86_64`: Intel Mac
- `arm64`: Apple Silicon (M1/M2/M3)

#### 2. Docker Desktop 설치

1. [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/) 다운로드
   - **Apple Silicon (M1/M2/M3)**: "Mac with Apple chip" 선택
   - **Intel Mac**: "Mac with Intel chip" 선택
2. 다운로드한 `Docker.dmg` 파일 실행
3. Docker 아이콘을 Applications 폴더로 드래그
4. Applications에서 Docker 실행
5. 시스템 권한 요청 시 비밀번호 입력

#### 3. 설치 확인

터미널에서 확인:

```bash
docker --version
docker compose version
```

정상 출력 예시:
```
Docker version 25.0.0, build 12345abc
Docker Compose version v2.24.0
```

---

## 🚀 n8n + OpenCode + Moltbot 설치

### 1. 프로젝트 파일 다운로드

#### Windows (PowerShell)

```powershell
# 다운로드할 폴더로 이동 (예: 문서 폴더)
cd ~\Documents

# 프로젝트 폴더 생성
mkdir n8n-workspace
cd n8n-workspace

# 파일 다운로드 (GitHub에서 다운로드하거나 직접 생성)
# 방법 1: Git 사용 (Git이 설치되어 있는 경우)
git clone <repository-url> .

# 방법 2: 파일을 직접 이 폴더에 복사
# - docker-compose.yml
# - .env.example
# - README.md
```

#### macOS (Terminal)

```bash
# 다운로드할 폴더로 이동 (예: 홈 폴더)
cd ~

# 프로젝트 폴더 생성
mkdir n8n-workspace
cd n8n-workspace

# 파일 다운로드 (GitHub에서 다운로드하거나 직접 생성)
# 방법 1: Git 사용
git clone <repository-url> .

# 방법 2: 파일을 직접 이 폴더에 복사
# - docker-compose.yml
# - .env.example
# - README.md
```

### 2. 환경 변수 설정

`.env.example` 파일을 `.env`로 복사하고 필요한 값을 수정합니다.

#### Windows (PowerShell)

```powershell
# .env 파일 생성
Copy-Item .env.example .env

# 메모장으로 편집
notepad .env
```

#### macOS (Terminal)

```bash
# .env 파일 생성
cp .env.example .env

# 텍스트 에디터로 편집
nano .env
# 또는
open -a TextEdit .env
```

**중요**: `.env` 파일에서 최소한 다음 항목을 변경하세요:

```env
# 보안을 위해 강력한 비밀번호로 변경
POSTGRES_PASSWORD=your_secure_password_here

# Moltbot 사용 시 API 키 입력 (선택사항)
ANTHROPIC_API_KEY=your_anthropic_api_key
```

### 3. shared 폴더 생성

n8n, OpenCode, Moltbot 간 파일 공유를 위한 폴더를 생성합니다.

#### Windows (PowerShell)

```powershell
mkdir shared
```

#### macOS (Terminal)

```bash
mkdir shared
```

### 4. Docker Compose 실행

#### 모든 서비스 시작

```bash
docker compose up -d
```

`-d` 옵션은 백그라운드 실행을 의미합니다.

#### 실행 로그 확인

```bash
# 모든 서비스의 로그 확인
docker compose logs -f

# 특정 서비스만 확인
docker compose logs -f n8n
docker compose logs -f opencode
docker compose logs -f moltbot
```

종료하려면 `Ctrl + C`를 누르세요.

#### 서비스 상태 확인

```bash
docker compose ps
```

정상 상태 예시:
```
NAME              IMAGE                                 STATUS          PORTS
n8n               n8nio/n8n:latest                      Up 2 minutes    0.0.0.0:5678->5678/tcp
n8n-postgres      postgres:16-alpine                    Up 2 minutes    5432/tcp
opencode          ghcr.io/anomalyco/opencode:latest     Up 2 minutes    0.0.0.0:8181->8181/tcp
moltbot           ghcr.io/moltbot/moltbot:latest        Up 2 minutes    0.0.0.0:18789->18789/tcp
```

### 5. 서비스 중지 및 재시작

```bash
# 서비스 중지
docker compose stop

# 서비스 재시작
docker compose start

# 서비스 중지 및 컨테이너 제거
docker compose down

# 서비스 중지, 컨테이너 및 볼륨 제거 (⚠️ 데이터 삭제됨)
docker compose down -v
```

---

## 🌐 서비스 접속

Docker Compose가 성공적으로 실행되면 다음 주소로 각 서비스에 접속할 수 있습니다.

### n8n 워크플로우 자동화

- **URL**: http://localhost:5678
- **초기 설정**:
  1. 브라우저에서 접속
  2. 계정 생성 (이메일, 비밀번호)
  3. 워크플로우 생성 시작

### OpenCode AI 코딩 어시스턴트

- **URL**: http://localhost:8181
- **사용법**:
  1. 브라우저에서 접속
  2. 코드 작성 또는 질문 입력
  3. AI의 코드 제안 및 도움 받기

### Moltbot AI 개인 비서

- **URL**: http://localhost:18789
- **사용법**:
  1. 브라우저에서 접속
  2. API 키 설정 (`.env` 파일에서 설정)
  3. AI 어시스턴트와 대화 시작

---

## 💡 사용 예제

### 예제 1: n8n에서 OpenCode 호출

n8n 워크플로우 내에서 HTTP Request 노드를 사용하여 OpenCode를 호출할 수 있습니다.

**HTTP Request 노드 설정:**
- Method: `POST`
- URL: `http://opencode:8181/api/generate`
- Body:
  ```json
  {
    "prompt": "Python으로 CSV 파일을 읽는 코드를 작성해주세요"
  }
  ```

### 예제 2: n8n에서 Moltbot 호출

**HTTP Request 노드 설정:**
- Method: `POST`
- URL: `http://moltbot:18789/api/chat`
- Body:
  ```json
  {
    "message": "오늘의 날씨 정보를 요약해주세요"
  }
  ```

### 예제 3: 파일 공유

`shared` 폴더를 통해 세 서비스 간 파일을 공유할 수 있습니다.

#### n8n에서 파일 저장

```javascript
// Code 노드에서 파일 저장
const fs = require('fs');
const filePath = '/shared/output.json';
fs.writeFileSync(filePath, JSON.stringify($input.all()));
return $input.all();
```

#### OpenCode에서 파일 읽기

```python
# /workspace 또는 /shared 경로에서 파일 접근
import json
with open('/shared/output.json', 'r') as f:
    data = json.load(f)
```

---

## 🔧 문제 해결

### Docker Desktop이 시작되지 않을 때

**Windows:**
1. WSL2가 제대로 설치되었는지 확인: `wsl --list --verbose`
2. Docker Desktop을 완전히 종료하고 재시작
3. Windows 업데이트 확인

**macOS:**
1. Docker Desktop을 완전히 종료 (상단 바에서 Quit)
2. Applications에서 Docker 재실행
3. macOS 업데이트 확인

### 포트 충돌 오류

다른 프로그램이 동일한 포트를 사용 중인 경우 발생합니다.

**해결 방법:**
1. `docker-compose.yml` 파일에서 포트 변경:
   ```yaml
   ports:
     - "5679:5678"  # n8n 포트를 5679로 변경
   ```
2. 서비스 재시작: `docker compose up -d`

### 서비스가 "Unhealthy" 상태일 때

```bash
# 서비스 로그 확인
docker compose logs <service-name>

# 예: PostgreSQL 로그 확인
docker compose logs postgres

# 컨테이너 재시작
docker compose restart <service-name>
```

### 데이터 초기화가 필요할 때

```bash
# ⚠️ 경고: 모든 데이터가 삭제됩니다
docker compose down -v
docker compose up -d
```

### 디스크 공간 부족

Docker 이미지와 볼륨 정리:

```bash
# 사용하지 않는 이미지 삭제
docker image prune -a

# 사용하지 않는 볼륨 삭제
docker volume prune

# 모든 미사용 리소스 삭제
docker system prune -a --volumes
```

---

## 📚 추가 리소스

### 공식 문서

- **n8n**: https://docs.n8n.io/
- **OpenCode**: https://opencode.ai/docs/
- **Moltbot**: https://docs.molt.bot/
- **Docker**: https://docs.docker.com/

### 참고 자료

- [Private AI Coding: OpenCode + Model Runner | Docker](https://www.docker.com/blog/opencode-docker-model-runner-private-ai-coding/)
- [Moltbot: The Ultimate Personal AI Assistant Guide for 2026](https://dev.to/czmilo/moltbot-the-ultimate-personal-ai-assistant-guide-for-2026-d4e)
- [OpenCode GitHub Repository](https://github.com/anomalyco/opencode)
- [Moltbot GitHub Repository](https://github.com/moltbot/moltbot)

### 커뮤니티

- **n8n Community**: https://community.n8n.io/
- **OpenCode Discord**: https://discord.gg/opencode
- **Docker Community**: https://www.docker.com/community/

---

## 🆘 도움말

문제가 해결되지 않거나 추가 도움이 필요한 경우:

1. **로그 확인**: `docker compose logs -f`
2. **서비스 상태 확인**: `docker compose ps`
3. **GitHub Issues**에 문제 보고
4. **커뮤니티 포럼**에 질문 게시

---

## 📝 라이선스

이 프로젝트는 교육 목적으로 제공됩니다. 각 서비스의 라이선스를 확인하세요:

- n8n: [Sustainable Use License](https://github.com/n8n-io/n8n/blob/master/LICENSE.md)
- OpenCode: [Apache License 2.0](https://github.com/anomalyco/opencode/blob/main/LICENSE)
- Moltbot: [MIT License](https://github.com/moltbot/moltbot/blob/main/LICENSE)

---

**즐거운 자동화와 AI 코딩 되세요! 🚀**
