#!/bin/bash

# n8n + OpenCode + Moltbot 설치 스크립트 (Mac/Linux)
# 사용법: chmod +x setup.sh && ./setup.sh

set -e

echo "================================================"
echo "  n8n + OpenCode + Moltbot 설치 스크립트"
echo "================================================"
echo ""

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Docker 설치 확인
echo "1. Docker 설치 확인 중..."
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker가 설치되어 있지 않습니다.${NC}"
    echo ""
    echo "Docker를 먼저 설치해주세요:"
    echo "  macOS: https://www.docker.com/products/docker-desktop/"
    echo "  Linux: https://docs.docker.com/engine/install/"
    exit 1
fi

if ! command -v docker compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose가 설치되어 있지 않습니다.${NC}"
    echo ""
    echo "Docker Compose를 먼저 설치해주세요:"
    echo "  https://docs.docker.com/compose/install/"
    exit 1
fi

echo -e "${GREEN}✓ Docker 설치 확인 완료${NC}"
docker --version
docker compose version
echo ""

# .env 파일 생성
echo "2. 환경 변수 파일 생성 중..."
if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${GREEN}✓ .env 파일 생성 완료${NC}"
        echo -e "${YELLOW}⚠️  .env 파일을 열어서 설정을 확인하고 수정하세요.${NC}"
        echo "  특히 POSTGRES_PASSWORD를 강력한 비밀번호로 변경하세요."
    else
        echo -e "${RED}❌ .env.example 파일을 찾을 수 없습니다.${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  .env 파일이 이미 존재합니다. 건너뜁니다.${NC}"
fi
echo ""

# shared 폴더 생성
echo "3. shared 폴더 생성 중..."
if [ ! -d "shared" ]; then
    mkdir -p shared
    echo -e "${GREEN}✓ shared 폴더 생성 완료${NC}"
else
    echo -e "${YELLOW}⚠️  shared 폴더가 이미 존재합니다. 건너뜁니다.${NC}"
fi
echo ""

# Docker 이미지 다운로드
echo "4. Docker 이미지 다운로드 중..."
echo "  (처음 실행 시 시간이 걸릴 수 있습니다)"
docker compose pull
echo -e "${GREEN}✓ Docker 이미지 다운로드 완료${NC}"
echo ""

# 서비스 시작
echo "5. 서비스 시작 중..."
docker compose up -d
echo -e "${GREEN}✓ 서비스 시작 완료${NC}"
echo ""

# 서비스 상태 확인 (30초 대기)
echo "6. 서비스 상태 확인 중... (30초 대기)"
sleep 30

docker compose ps
echo ""

# 접속 정보 출력
echo "================================================"
echo -e "${GREEN}  설치가 완료되었습니다! 🎉${NC}"
echo "================================================"
echo ""
echo "다음 주소로 접속하세요:"
echo ""
echo "  📊 n8n 워크플로우 자동화:"
echo "     http://localhost:5678"
echo ""
echo "  🤖 OpenCode AI 코딩 어시스턴트:"
echo "     http://localhost:8181"
echo ""
echo "  🦞 Moltbot AI 개인 비서:"
echo "     http://localhost:18789"
echo ""
echo "================================================"
echo ""
echo "유용한 명령어:"
echo "  - 로그 확인:        docker compose logs -f"
echo "  - 서비스 중지:      docker compose stop"
echo "  - 서비스 재시작:    docker compose start"
echo "  - 서비스 제거:      docker compose down"
echo ""
echo "자세한 내용은 README.md 파일을 참고하세요."
echo ""
