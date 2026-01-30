# n8n + OpenCode + Moltbot 설치 스크립트 (Windows PowerShell)
# 사용법: .\setup.ps1

$ErrorActionPreference = "Stop"

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  n8n + OpenCode + Moltbot 설치 스크립트" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Docker 설치 확인
Write-Host "1. Docker 설치 확인 중..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    $dockerComposeVersion = docker compose version
    Write-Host "✓ Docker 설치 확인 완료" -ForegroundColor Green
    Write-Host "  $dockerVersion" -ForegroundColor Gray
    Write-Host "  $dockerComposeVersion" -ForegroundColor Gray
} catch {
    Write-Host "❌ Docker가 설치되어 있지 않습니다." -ForegroundColor Red
    Write-Host ""
    Write-Host "Docker Desktop을 먼저 설치해주세요:" -ForegroundColor Yellow
    Write-Host "  https://www.docker.com/products/docker-desktop/" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# .env 파일 생성
Write-Host "2. 환경 변수 파일 생성 중..." -ForegroundColor Yellow
if (-Not (Test-Path ".env")) {
    if (Test-Path ".env.example") {
        Copy-Item ".env.example" ".env"
        Write-Host "✓ .env 파일 생성 완료" -ForegroundColor Green
        Write-Host "⚠️  .env 파일을 열어서 설정을 확인하고 수정하세요." -ForegroundColor Yellow
        Write-Host "  특히 POSTGRES_PASSWORD를 강력한 비밀번호로 변경하세요." -ForegroundColor Yellow
    } else {
        Write-Host "❌ .env.example 파일을 찾을 수 없습니다." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "⚠️  .env 파일이 이미 존재합니다. 건너뜁니다." -ForegroundColor Yellow
}
Write-Host ""

# shared 폴더 생성
Write-Host "3. shared 폴더 생성 중..." -ForegroundColor Yellow
if (-Not (Test-Path "shared")) {
    New-Item -ItemType Directory -Path "shared" | Out-Null
    Write-Host "✓ shared 폴더 생성 완료" -ForegroundColor Green
} else {
    Write-Host "⚠️  shared 폴더가 이미 존재합니다. 건너뜁니다." -ForegroundColor Yellow
}
Write-Host ""

# Docker 이미지 다운로드
Write-Host "4. Docker 이미지 다운로드 중..." -ForegroundColor Yellow
Write-Host "  (처음 실행 시 시간이 걸릴 수 있습니다)" -ForegroundColor Gray
docker compose pull
Write-Host "✓ Docker 이미지 다운로드 완료" -ForegroundColor Green
Write-Host ""

# 서비스 시작
Write-Host "5. 서비스 시작 중..." -ForegroundColor Yellow
docker compose up -d
Write-Host "✓ 서비스 시작 완료" -ForegroundColor Green
Write-Host ""

# 서비스 상태 확인 (30초 대기)
Write-Host "6. 서비스 상태 확인 중... (30초 대기)" -ForegroundColor Yellow
Start-Sleep -Seconds 30

docker compose ps
Write-Host ""

# 접속 정보 출력
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  설치가 완료되었습니다! 🎉" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "다음 주소로 접속하세요:" -ForegroundColor White
Write-Host ""
Write-Host "  📊 n8n 워크플로우 자동화:" -ForegroundColor Cyan
Write-Host "     http://localhost:5678" -ForegroundColor White
Write-Host ""
Write-Host "  🤖 OpenCode AI 코딩 어시스턴트:" -ForegroundColor Cyan
Write-Host "     http://localhost:8181" -ForegroundColor White
Write-Host ""
Write-Host "  🦞 Moltbot AI 개인 비서:" -ForegroundColor Cyan
Write-Host "     http://localhost:18789" -ForegroundColor White
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "유용한 명령어:" -ForegroundColor Yellow
Write-Host "  - 로그 확인:        docker compose logs -f" -ForegroundColor Gray
Write-Host "  - 서비스 중지:      docker compose stop" -ForegroundColor Gray
Write-Host "  - 서비스 재시작:    docker compose start" -ForegroundColor Gray
Write-Host "  - 서비스 제거:      docker compose down" -ForegroundColor Gray
Write-Host ""
Write-Host "자세한 내용은 README.md 파일을 참고하세요." -ForegroundColor Yellow
Write-Host ""
