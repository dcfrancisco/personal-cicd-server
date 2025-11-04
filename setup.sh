#!/bin/bash

# CI/CD Environment Setup Script
# This script initializes all directories and configurations for the docker-compose setup

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VOLUME_DIR="$PROJECT_ROOT/volume"

echo "🚀 Setting up CI/CD environment..."

# Create volume directories
echo "📁 Creating volume directories..."
mkdir -p "$VOLUME_DIR"/{jenkins,nexus,sonarqube/{data,logs,extensions},postgres,gitlab/{config,data,logs}}

# Set proper permissions
echo "🔐 Setting permissions..."
chmod -R 755 "$VOLUME_DIR"

# Create init scripts for services
echo "📝 Creating initialization scripts..."

# Jenkins init script
mkdir -p "$VOLUME_DIR/jenkins/init.groovy.d"
cat > "$VOLUME_DIR/jenkins/init.groovy.d/1-skip-setup.groovy" << 'EOF'
import jenkins.model.Jenkins
import jenkins.security.s2m.AdminWhitelistRule

// Skip setup wizard
Jenkins.instance.setSecurityRealm(new hudson.security.SecurityRealm() {})
Jenkins.instance.save()

// Disable Jenkins setup wizard
Jenkins.instance.getPluginManager().plugins.each {
  it.active = true
}
EOF

# SonarQube extensions setup
echo "📝 Creating SonarQube initialization..."
cat > "$VOLUME_DIR/sonarqube/init.sql" << 'EOF'
-- SonarQube initialization script
-- This script can be used to pre-configure SonarQube if needed
SELECT 1;
EOF

# Create .gitignore for volume directory
cat > "$VOLUME_DIR/.gitignore" << 'EOF'
# Volume data - do not commit
*
!.gitignore
!.env.example
EOF

# Create environment file template
cat > "$PROJECT_ROOT/.env.example" << 'EOF'
# Jenkins Configuration
JENKINS_PORT=8080

# Nexus Configuration
NEXUS_PORT=8081

# SonarQube Configuration
SONARQUBE_PORT=9000
SONARQUBE_DB_USER=sonarqube
SONARQUBE_DB_PASSWORD=sonarqube_password
SONARQUBE_DB_NAME=sonarqube

# PostgreSQL Configuration
POSTGRES_USER=sonarqube
POSTGRES_PASSWORD=sonarqube_password
POSTGRES_DB=sonarqube
POSTGRES_PORT=5432

# GitLab Configuration
GITLAB_PORT=80
GITLAB_SSH_PORT=2222
GITLAB_ROOT_PASSWORD=gitlabadmin123
GITLAB_HOSTNAME=gitlab.local
EOF

echo "✅ Directory structure created"
echo ""
echo "📋 Summary of created directories:"
tree "$VOLUME_DIR" 2>/dev/null || find "$VOLUME_DIR" -type d

echo ""
echo "🎉 Setup complete! You can now run:"
echo ""
echo "  docker-compose up -d"
echo ""
echo "📝 Access your services at:"
echo "  Jenkins:   http://localhost:8080"
echo "  Nexus:     http://localhost:8081"
echo "  SonarQube: http://localhost:9000"
echo "  GitLab:    http://localhost"
echo ""
