#!/bin/bash

# Kali Linux Docker Helper Script
# Memudahkan penggunaan Docker container Kali Linux

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

CONTAINER_NAME="kali-linux"
IMAGE_NAME="kali-linux-complete:latest"

show_help() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  Kali Linux Docker Helper Script       ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}Usage:${NC} $0 [command] [options]"
    echo ""
    echo -e "${YELLOW}Commands:${NC}"
    echo "  build              Build the Kali Linux image"
    echo "  up                 Start the container with docker-compose"
    echo "  down               Stop and remove container"
    echo "  shell              Open bash shell in running container"
    echo "  exec <cmd>         Execute command in container"
    echo "  stop               Stop the running container"
    echo "  start              Start the container"
    echo "  restart            Restart the container"
    echo "  logs               Show container logs"
    echo "  ps                 Show running containers"
    echo "  images             Show available images"
    echo "  clean              Remove stopped containers and unused images"
    echo "  status             Show container status"
    echo "  help               Show this help message"
    echo ""
}

build_image() {
    echo -e "${YELLOW}[*] Building Kali Linux image...${NC}"
    docker-compose build --no-cache
    echo -e "${GREEN}[✓] Image built successfully!${NC}"
}

start_container() {
    echo -e "${YELLOW}[*] Starting Kali Linux container...${NC}"
    docker-compose up -d
    sleep 2
    echo -e "${GREEN}[✓] Container started!${NC}"
    echo -e "${BLUE}[i] Access with: docker-compose exec kali bash${NC}"
}

stop_container() {
    echo -e "${YELLOW}[*] Stopping Kali Linux container...${NC}"
    docker-compose stop
    echo -e "${GREEN}[✓] Container stopped!${NC}"
}

down_container() {
    echo -e "${YELLOW}[*] Removing Kali Linux container...${NC}"
    docker-compose down
    echo -e "${GREEN}[✓] Container removed!${NC}"
}

open_shell() {
    echo -e "${BLUE}[i] Opening shell...${NC}"
    docker-compose exec kali bash
}

exec_command() {
    local cmd="$@"
    docker-compose exec kali $cmd
}

restart_container() {
    echo -e "${YELLOW}[*] Restarting Kali Linux container...${NC}"
    docker-compose restart
    echo -e "${GREEN}[✓] Container restarted!${NC}"
}

show_logs() {
    docker-compose logs -f kali
}

show_ps() {
    echo -e "${YELLOW}Running Containers:${NC}"
    docker ps --filter "name=kali" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

show_images() {
    echo -e "${YELLOW}Available Images:${NC}"
    docker images | grep -E "kali|REPOSITORY" || echo "No Kali images found"
}

show_status() {
    echo -e "${YELLOW}Container Status:${NC}"
    if docker-compose ps | grep -q "kali.*Up"; then
        echo -e "${GREEN}[✓] Container is running${NC}"
        docker-compose ps
    else
        echo -e "${RED}[✗] Container is not running${NC}"
    fi
}

cleanup() {
    echo -e "${YELLOW}[*] Cleaning up...${NC}"
    docker container prune -f
    docker image prune -f
    echo -e "${GREEN}[✓] Cleanup complete!${NC}"
}

# Main script
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

case "$1" in
    build)
        build_image
        ;;
    up)
        build_image
        start_container
        ;;
    down)
        down_container
        ;;
    shell)
        open_shell
        ;;
    exec)
        shift
        exec_command "$@"
        ;;
    stop)
        stop_container
        ;;
    start)
        start_container
        ;;
    restart)
        restart_container
        ;;
    logs)
        show_logs
        ;;
    ps)
        show_ps
        ;;
    images)
        show_images
        ;;
    status)
        show_status
        ;;
    clean)
        cleanup
        ;;
    help|-h|--help)
        show_help
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        show_help
        exit 1
        ;;
esac
