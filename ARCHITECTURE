#!/bin/bash

# Visual Architecture Diagram

cat << "EOF"

╔════════════════════════════════════════════════════════════════════════════╗
║                  🏗️  CI/CD ARCHITECTURE - Docker Compose                  ║
╚════════════════════════════════════════════════════════════════════════════╝

┌─────────────────────────────────────────────────────────────────────────────┐
│                           🖥️  HOST MACHINE                                  │
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │                      📦 Docker Container Network                      │ │
│  │                                                                       │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │ │
│  │  │   Jenkins    │  │    Nexus     │  │   GitLab     │               │ │
│  │  │   :8080      │  │   :8081      │  │   :80,2222   │               │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘               │ │
│  │                                                                       │ │
│  │  ┌──────────────┐  ┌──────────────┐                                 │ │
│  │  │  SonarQube   │  │  PostgreSQL  │                                 │ │
│  │  │   :9000      │  │   :5432      │                                 │ │
│  │  └──────────────┘  └──────────────┘                                 │ │
│  │         ▲                   ▲                                         │ │
│  │         │                   │                                         │ │
│  │         │           (database connection)                             │ │
│  │         └───────────────────┘                                         │ │
│  │                                                                       │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │                      💾 PERSISTENT VOLUMES                            │ │
│  │                                                                       │ │
│  │  ./volume/                                                           │ │
│  │    ├── jenkins/          (Jenkins home)                              │ │
│  │    ├── nexus/            (Artifacts)                                 │ │
│  │    ├── sonarqube/        (Quality metrics)                           │ │
│  │    ├── postgres/         (Database)                                  │ │
│  │    └── gitlab/           (Repositories)                              │ │
│  │                                                                       │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│  ┌───────────────────────────────────────────────────────────────────────┐ │
│  │               🚀 STARTUP FLOW (./start.sh)                            │ │
│  │                                                                       │ │
│  │  1. Create volume directories                                        │ │
│  │  2. Check Docker & Docker Compose                                    │ │
│  │  3. Build custom Docker images                                       │ │
│  │  4. Start all containers                                             │ │
│  │  5. Wait for services to be healthy                                  │ │
│  │  6. Display access information                                       │ │
│  │                                                                       │ │
│  └───────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘


╔════════════════════════════════════════════════════════════════════════════╗
║                       📱 SERVICE ACCESS ENDPOINTS                          ║
╚════════════════════════════════════════════════════════════════════════════╝

  🔴 Jenkins (CI/CD Orchestration)
     └─ http://localhost:8080
     └─ Port: 8080
     └─ Health: ✓ Healthcheck enabled
     └─ Data: ./volume/jenkins/

  🔴 Nexus (Artifact Repository)
     └─ http://localhost:8081
     └─ Port: 8081
     └─ Health: ✓ Auto-restart
     └─ Data: ./volume/nexus/

  🔴 SonarQube (Code Quality)
     └─ http://localhost:9000
     └─ Port: 9000
     └─ Health: ✓ Healthcheck enabled
     └─ Data: ./volume/sonarqube/
     └─ Depends on: PostgreSQL

  🔴 GitLab (Repository Manager)
     └─ http://localhost (HTTP)
     └─ localhost:2222 (SSH)
     └─ Ports: 80, 2222
     └─ Health: ✓ Healthcheck enabled
     └─ Data: ./volume/gitlab/
     └─ Note: Takes 2-3 minutes to start

  🔴 PostgreSQL (Database)
     └─ localhost:5432
     └─ Port: 5432
     └─ Health: ✓ Healthcheck enabled
     └─ Used by: SonarQube
     └─ Data: ./volume/postgres/


╔════════════════════════════════════════════════════════════════════════════╗
║                        ⚙️  QUICK COMMANDS                                  ║
╚════════════════════════════════════════════════════════════════════════════╝

  Start all services:
    ./start.sh
    or
    make start

  Stop all services:
    ./stop.sh
    or
    make stop

  Check status:
    ./status.sh
    or
    make status

  View logs:
    docker-compose logs -f
    or
    make logs

  View specific service logs:
    docker-compose logs -f jenkins
    docker-compose logs -f sonarqube
    docker-compose logs -f gitlab

  Restart services:
    docker-compose restart
    or
    make restart

  Reset everything:
    docker-compose down -v && rm -rf volume/ && ./start.sh


╔════════════════════════════════════════════════════════════════════════════╗
║                      🔐 DEFAULT CREDENTIALS                                ║
╚════════════════════════════════════════════════════════════════════════════╝

  Jenkins:
    └─ Username: Retrieved from container
    └─ Command: docker exec jenkins-instance cat /var/jenkins_home/secrets/initialAdminPassword

  Nexus:
    └─ Username: admin
    └─ Password: Check ./volume/nexus/admin.password

  SonarQube:
    └─ Username: admin
    └─ Password: admin
    └─ ⚠️  Change on first login!

  GitLab:
    └─ Username: root
    └─ Password: gitlabadmin123
    └─ ⚠️  Change on first login!

  PostgreSQL:
    └─ Username: sonarqube
    └─ Password: sonarqube_password


╔════════════════════════════════════════════════════════════════════════════╗
║                         📁 PROJECT STRUCTURE                               ║
╚════════════════════════════════════════════════════════════════════════════╝

  personal-cicd-server/
  ├── start.sh                    ← MAIN ENTRY POINT (./start.sh)
  ├── stop.sh                     ← Stop services
  ├── status.sh                   ← Check status
  ├── setup.sh                    ← Manual setup
  ├── docker-compose.yml          ← Main configuration
  ├── Makefile                    ← Make commands
  ├── README.md                   ← Full documentation
  ├── DOCKER_COMPOSE_SETUP.md     ← Setup guide
  ├── SETUP_COMPLETE.md           ← Integration tips
  │
  ├── jenkins/
  │  ├── Dockerfile
  │  ├── plugins.txt              ← Customize plugins
  │  └── init.groovy.d/
  │
  ├── nexus/
  │  ├── Dockerfile
  │  └── ansible/
  │
  ├── sonarqube/
  │  ├── Dockerfile
  │  ├── sonar.properties         ← Customize config
  │  └── init.sql                 ← DB initialization
  │
  ├── gitlab/
  │  └── Dockerfile
  │
  ├── volume/                     ← AUTO-CREATED DATA
  │  ├── jenkins/
  │  ├── nexus/
  │  ├── sonarqube/
  │  ├── postgres/
  │  └── gitlab/
  │
  └── assets/
     └── docker_containers.png


╔════════════════════════════════════════════════════════════════════════════╗
║                       ✅ SETUP CHECKLIST                                   ║
╚════════════════════════════════════════════════════════════════════════════╝

  Before First Run:
    ☐ Docker installed
    ☐ Docker Compose installed
    ☐ Port 80, 8080, 8081, 9000 available
    ☐ At least 10GB free disk space
    ☐ Minimum 4GB RAM available

  First Run:
    ☐ cd personal-cicd-server
    ☐ ./start.sh
    ☐ Wait 2-3 minutes for services to start
    ☐ Check status: ./status.sh

  Initial Configuration:
    ☐ Access Jenkins (http://localhost:8080)
    ☐ Access Nexus (http://localhost:8081)
    ☐ Access SonarQube (http://localhost:9000)
    ☐ Access GitLab (http://localhost)
    ☐ Change all default passwords
    ☐ Configure webhooks
    ☐ Create Git repositories

  Ongoing:
    ☐ Monitor with: ./status.sh
    ☐ Check logs: docker-compose logs -f
    ☐ Back up volume/: tar czf backup.tar.gz volume/


╔════════════════════════════════════════════════════════════════════════════╗
║                    🎯 EVERYTHING IS AUTOMATED! 🚀                          ║
║                  Just run: ./start.sh                                       ║
╚════════════════════════════════════════════════════════════════════════════╝
