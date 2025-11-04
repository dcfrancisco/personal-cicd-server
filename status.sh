#!/bin/bash

# Quick reference guide and diagnostic script

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔════════════════════════════════════════════════════════╗"
echo "║   CI/CD Stack - Quick Reference & Diagnostics          ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

echo "📊 Current Service Status:"
docker-compose ps

echo ""
echo "🔍 Service Health:"
echo ""

# Check each service
services=("jenkins-instance" "nexus-instance" "postgres-instance" "sonarqube-instance" "gitlab-instance")

for service in "${services[@]}"; do
    if docker ps | grep -q "$service"; then
        status=$(docker inspect --format='{{.State.Health.Status}}' "$service" 2>/dev/null || echo "unknown")
        echo "  $service: $status"
    else
        echo "  $service: not running"
    fi
done

echo ""
echo "📝 Log Files (tail -f to stream):"
echo "  docker-compose logs -f                    # All services"
echo "  docker-compose logs -f jenkins            # Jenkins"
echo "  docker-compose logs -f nexus              # Nexus"
echo "  docker-compose logs -f sonarqube          # SonarQube"
echo "  docker-compose logs -f postgres           # PostgreSQL"
echo "  docker-compose logs -f gitlab             # GitLab"
echo ""

echo "🔧 Common Tasks:"
echo ""
echo "  View service logs:"
echo "    docker-compose logs -f [service]"
echo ""
echo "  Execute commands in containers:"
echo "    docker exec jenkins-instance /bin/bash"
echo "    docker exec postgres-instance psql -U sonarqube"
echo ""
echo "  Restart a service:"
echo "    docker-compose restart [service]"
echo ""
echo "  Get Jenkins initial password:"
echo "    docker exec jenkins-instance cat /var/jenkins_home/secrets/initialAdminPassword"
echo ""
echo "  Get Nexus initial password:"
echo "    cat volume/nexus/admin.password"
echo ""

echo "💾 Storage Information:"
du -sh "$PROJECT_ROOT/volume" 2>/dev/null || echo "  volume directory not yet created"

echo ""
echo "🐳 Docker Information:"
docker --version
docker-compose --version
echo ""
