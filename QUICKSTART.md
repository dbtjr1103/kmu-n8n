# 빠른 시작 가이드 (Quick Start)

5분 안에 n8n + OpenCode + Moltbot을 실행해보세요!

## 사전 준비

- **Docker Desktop 설치 필수**
  - Windows: https://www.docker.com/products/docker-desktop/
  - macOS: https://www.docker.com/products/docker-desktop/

## 설치 단계

### Windows 사용자

1. **파일 다운로드**
   - 이 폴더를 다운로드하거나 복제합니다
   - 폴더 위치: `C:\Users\사용자명\Documents\n8n-workspace`

2. **PowerShell 실행**
   - 폴더에서 우클릭 → "PowerShell에서 열기" 선택

3. **설치 스크립트 실행**
   ```powershell
   .\setup.ps1
   ```

4. **접속**
   - n8n: http://localhost:5678
   - OpenCode: http://localhost:8181
   - Moltbot: http://localhost:18789

### macOS 사용자

1. **파일 다운로드**
   - 이 폴더를 다운로드하거나 복제합니다
   - 폴더 위치: `~/n8n-workspace`

2. **Terminal 실행**
   - 폴더로 이동: `cd ~/n8n-workspace`

3. **설치 스크립트 실행**
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

4. **접속**
   - n8n: http://localhost:5678
   - OpenCode: http://localhost:8181
   - Moltbot: http://localhost:18789

## 수동 설치 (고급)

스크립트를 사용하지 않고 직접 설치하려면:

```bash
# 1. 환경 변수 파일 생성
cp .env.example .env

# 2. shared 폴더 생성
mkdir shared

# 3. Docker Compose 실행
docker compose up -d

# 4. 로그 확인
docker compose logs -f
```

## 서비스 관리

### 서비스 중지
```bash
docker compose stop
```

### 서비스 재시작
```bash
docker compose start
```

### 서비스 완전 제거 (데이터 보존)
```bash
docker compose down
```

### 서비스 완전 제거 (데이터 삭제)
```bash
docker compose down -v
```

## 문제 해결

### Docker Desktop이 실행되지 않을 때
1. Docker Desktop을 완전히 종료
2. 컴퓨터 재시작
3. Docker Desktop 재실행

### 포트 충돌 오류
`docker-compose.yml` 파일에서 포트 번호 변경:

```yaml
ports:
  - "5679:5678"  # 5678 대신 5679 사용
```

### 더 많은 도움이 필요하면
- README.md 전체 가이드 참조
- GitHub Issues에 문제 보고

---

**즐거운 자동화 되세요! 🚀**
