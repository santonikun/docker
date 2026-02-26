#!/bin/bash

# Quick file transfer script for Kali Linux Docker

set -e

CONTAINER_NAME="kali-linux"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_help() {
    echo -e "${BLUE}Kali Docker File Transfer${NC}"
    echo ""
    echo -e "${GREEN}Usage:${NC}"
    echo "  ./transfer.sh to <local-file> <container-path>"
    echo "  ./transfer.sh from <container-path> <local-path>"
    echo "  ./transfer.sh help"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  # Copy file TO container"
    echo "  ./transfer.sh to ./exploit.py /root/exploits/"
    echo ""
    echo "  # Copy file FROM container"
    echo "  ./transfer.sh from /root/report.txt ./"
}

if [ $# -eq 0 ] || [[ "$1" == "help" ]] || [[ "$1" == "-h" ]]; then
    show_help
    exit 0
fi

case "$1" in
    to)
        if [ $# -lt 3 ]; then
            echo -e "${RED}Error: Missing arguments${NC}"
            show_help
            exit 1
        fi
        local_file="$2"
        container_path="$3"
        
        if [ ! -f "$local_file" ]; then
            echo -e "${RED}Error: Local file not found: $local_file${NC}"
            exit 1
        fi
        
        echo -e "${YELLOW}[*] Copying $local_file to $CONTAINER_NAME:$container_path${NC}"
        docker cp "$local_file" "$CONTAINER_NAME:$container_path"
        echo -e "${GREEN}[✓] Done!${NC}"
        ;;
        
    from)
        if [ $# -lt 3 ]; then
            echo -e "${RED}Error: Missing arguments${NC}"
            show_help
            exit 1
        fi
        container_path="$2"
        local_path="$3"
        
        echo -e "${YELLOW}[*] Copying $CONTAINER_NAME:$container_path to $local_path${NC}"
        docker cp "$CONTAINER_NAME:$container_path" "$local_path"
        echo -e "${GREEN}[✓] Done!${NC}"
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        show_help
        exit 1
        ;;
esac
