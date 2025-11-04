#!/bin/bash

# Complete CI/CD Environment Startup Script
# This script handles everything needed to start the full stack

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VOLUME_DIR="$PROJECT_ROOT/volume"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════╗
║   CI/CD Environment Setup & Startup Script        ║
║   Jenkins | Nexus | GitLab | SonarQube            ║
╚═══════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Step 1: Create volume directories
echo -e "${YELLOW}Step 1: Creating volume directories...${NC}"
mkdir -p "$VOLUME_DIR"/{jenkins,nexus,sonarqube/{data,logs,extensions},postgres,gitlab/{config,data,logs}}
chmod -R 755 "$VOLUME_DIR"
echo -e "${GREEN}✓ Volume directories created${NC}"

# Step 2: Check Docker
echo -e "${YELLOW}Step 2: Checking Docker installation...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker is installed${NC}"

# Step 3: Check Docker Compose
echo -e "${YELLOW}Step 3: Checking Docker Compose installation...${NC}"
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}✗ Docker Compose is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker Compose is installed${NC}"

# Step 4: Build custom images
echo -e "${YELLOW}Step 4: Building custom Docker images...${NC}"
cd "$PROJECT_ROOT"
docker-compose build --no-cache
echo -e "${GREEN}✓ Docker images built${NC}"

# Step 5: Start all services
echo -e "${YELLOW}Step 5: Starting all services...${NC}"
docker-compose up -d
echo -e "${GREEN}✓ All services started${NC}"

# Step 6: Wait for services to be ready
echo -e "${YELLOW}Step 6: Waiting for services to be ready...${NC}"
echo "This may take 2-5 minutes..."

# Function to check service health
check_service() {
    local service_name=$1
    local url=$2
    local max_attempts=60
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -sf "$url" > /dev/null 2>&1; then
            echo -e "${GREEN}✓ $service_name is ready${NC}"
            return 0
        fi
        attempt=$((attempt + 1))
        echo -n "."
        sleep 2
    done
    
    echo -e "${RED}✗ $service_name failed to start${NC}"
    return 1
}

echo ""
echo "Checking services..."
check_service "Jenkins" "http://localhost:8080" || true
check_service "Nexus" "http://localhost:8081" || true
check_service "SonarQube" "http://localhost:9000" || true
check_service "GitLab" "http://localhost" || true

# Step 7: Display information
echo ""
echo -e "${GREEN}"
cat << "EOF"
╔═══════════════════════════════════════════════════╗
║        🎉 Setup Complete!                         ║
║                                                   ║
║  All services are starting up...                  ║
╚═══════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${BLUE}📋 Service Access Information:${NC}"
echo ""
echo -e "${YELLOW}Jenkins${NC}"
echo "  URL: http://localhost:8080"
echo "  Initial password: docker exec jenkins-instance cat /var/jenkins_home/secrets/initialAdminPassword"
echo ""
echo -e "${YELLOW}Nexus${NC}"
echo "  URL: http://localhost:8081"
echo "  Credentials: Check ./volume/nexus/admin.password"
echo ""
echo -e "${YELLOW}SonarQube${NC}"
echo "  URL: http://localhost:9000"
echo "  Default User: admin"
echo "  Default Password: admin"
echo "  ⚠️  Change password on first login!"
echo ""
echo -e "${YELLOW}GitLab${NC}"
echo "  URL: http://localhost"
echo "  SSH: ssh -i your_key -p 2222 git@localhost"
echo "  Default User: root"
echo "  Default Password: gitlabadmin123"
echo "  ⚠️  Change password on first login!"
echo ""
echo -e "${BLUE}📁 Data Volumes:${NC}"
echo "  All data is persisted in: $VOLUME_DIR"
echo ""
echo -e "${BLUE}🛠️  Useful Commands:${NC}"
echo "  View logs:              docker-compose logs -f [service-name]"
echo "  Stop services:          docker-compose down"
echo "  Check status:           docker-compose ps"
echo "  Clean everything:       docker-compose down -v"
echo ""
echo -e "${BLUE}📝 Configuration Files:${NC}"
echo "  Jenkins plugins:        ./jenkins/plugins.txt"
echo "  SonarQube config:       ./sonarqube/sonar.properties"
echo "  Docker Compose:         ./docker-compose.yml"
echo ""
