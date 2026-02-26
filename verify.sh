#!/bin/bash

# Quick verification script untuk Kali Linux Docker setup

set -e

echo "╔═══════════════════════════════════════════════════╗"
echo "║  Kali Linux Docker - Quick Verification Script    ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

check_docker() {
    echo -e "${BLUE}[1/5] Checking Docker installation...${NC}"
    if command -v docker &> /dev/null; then
        docker_version=$(docker --version)
        echo -e "${GREEN}✓ Docker found: $docker_version${NC}"
    else
        echo -e "${RED}✗ Docker not installed!${NC}"
        return 1
    fi
}

check_docker_compose() {
    echo -e "${BLUE}[2/5] Checking Docker Compose...${NC}"
    if command -v docker-compose &> /dev/null; then
        compose_version=$(docker-compose --version)
        echo -e "${GREEN}✓ Docker Compose found: $compose_version${NC}"
    else
        echo -e "${RED}✗ Docker Compose not installed!${NC}"
        return 1
    fi
}

check_files() {
    echo -e "${BLUE}[3/5] Checking required files...${NC}"
    
    files=("Dockerfile" "docker-compose.yml" "README.md" "kali-docker.sh" "transfer.sh")
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "${GREEN}✓ Found $file${NC}"
        else
            echo -e "${RED}✗ Missing $file${NC}"
            return 1
        fi
    done
}

check_docker_daemon() {
    echo -e "${BLUE}[4/5] Checking Docker daemon...${NC}"
    if docker ps &> /dev/null; then
        echo -e "${GREEN}✓ Docker daemon is running${NC}"
    else
        echo -e "${RED}✗ Docker daemon is not running!${NC}"
        return 1
    fi
}

check_disk_space() {
    echo -e "${BLUE}[5/5] Checking disk space...${NC}"
    available=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
    required=5
    
    if [ "$available" -gt "$required" ]; then
        echo -e "${GREEN}✓ Sufficient disk space: ${available}GB available (${required}GB required)${NC}"
    else
        echo -e "${RED}✗ Low disk space: ${available}GB available (${required}GB required)${NC}"
        return 1
    fi
}

show_next_steps() {
    echo ""
    echo "╔═══════════════════════════════════════════════════╗"
    echo "║               Next Steps                          ║"
    echo "╚═══════════════════════════════════════════════════╝"
    echo ""
    echo -e "${YELLOW}1. Build the Docker image:${NC}"
    echo "   ./kali-docker.sh build"
    echo "   Or: docker-compose build"
    echo ""
    echo -e "${YELLOW}2. Start the container:${NC}"
    echo "   ./kali-docker.sh up"
    echo "   Or: docker-compose up -d"
    echo ""
    echo -e "${YELLOW}3. Open a shell:${NC}"
    echo "   ./kali-docker.sh shell"
    echo "   Or: docker-compose exec kali bash"
    echo ""
    echo -e "${YELLOW}4. View this help again:${NC}"
    echo "   ./kali-docker.sh help"
    echo ""
    echo -e "${YELLOW}5. View cheat sheet:${NC}"
    echo "   cat CHEATSHEET.md"
    echo ""
    echo -e "${YELLOW}6. View advanced guide:${NC}"
    echo "   cat ADVANCED.md"
    echo ""
}

# Run checks
all_passed=true

check_docker || all_passed=false
echo ""
check_docker_compose || all_passed=false
echo ""
check_files || all_passed=false
echo ""
check_docker_daemon || all_passed=false
echo ""
check_disk_space || all_passed=false
echo ""

# Show results
echo "╔═══════════════════════════════════════════════════╗"
echo "║               Verification Result                 ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""

if [ "$all_passed" = true ]; then
    echo -e "${GREEN}✓ All checks passed! You're ready to get started.${NC}"
    show_next_steps
    exit 0
else
    echo -e "${RED}✗ Some checks failed. Please fix the issues above.${NC}"
    exit 1
fi
