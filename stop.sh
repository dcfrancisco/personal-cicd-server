#!/bin/bash

# Stop and cleanup script
# This script safely stops all services

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🛑 Stopping CI/CD Environment...${NC}"
echo ""

cd "$PROJECT_ROOT"

# Check if services are running
if ! docker-compose ps | grep -q "Up"; then
    echo -e "${YELLOW}No services are currently running${NC}"
    exit 0
fi

# Stop services
echo -e "${YELLOW}Stopping containers...${NC}"
docker-compose stop
echo -e "${GREEN}✓ Containers stopped${NC}"

echo ""
echo -e "${YELLOW}Options:${NC}"
echo "  - Data is preserved in ./volume/ directory"
echo "  - To remove containers: docker-compose down"
echo "  - To remove everything including volumes: docker-compose down -v"
echo ""
echo -e "${GREEN}Services stopped successfully!${NC}"
