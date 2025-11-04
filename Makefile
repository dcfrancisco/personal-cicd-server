.PHONY: help start stop restart status logs clean setup build

help:
	@echo "╔════════════════════════════════════════════════════╗"
	@echo "║   CI/CD Stack - Available Commands                 ║"
	@echo "╚════════════════════════════════════════════════════╝"
	@echo ""
	@echo "Usage: make [command]"
	@echo ""
	@echo "Commands:"
	@echo "  start          - Start all services (automated setup)"
	@echo "  stop           - Stop all services"
	@echo "  restart        - Restart all services"
	@echo "  status         - Show service status and diagnostics"
	@echo "  logs           - Show logs from all services"
	@echo "  logs-jenkins   - Show Jenkins logs"
	@echo "  logs-nexus     - Show Nexus logs"
	@echo "  logs-postgres  - Show PostgreSQL logs"
	@echo "  logs-sonarqube - Show SonarQube logs"
	@echo "  logs-gitlab    - Show GitLab logs"
	@echo "  build          - Build Docker images"
	@echo "  setup          - Setup volume directories"
	@echo "  clean          - Remove containers and volumes"
	@echo "  help           - Show this help message"
	@echo ""

start:
	@./start.sh

stop:
	@./stop.sh

restart:
	@docker-compose restart

status:
	@./status.sh

logs:
	@docker-compose logs -f

logs-jenkins:
	@docker-compose logs -f jenkins

logs-nexus:
	@docker-compose logs -f nexus

logs-postgres:
	@docker-compose logs -f postgres

logs-sonarqube:
	@docker-compose logs -f sonarqube

logs-gitlab:
	@docker-compose logs -f gitlab

build:
	@docker-compose build --no-cache

setup:
	@./setup.sh

clean:
	@echo "⚠️  This will remove all containers and volumes!"
	@echo "Are you sure? [y/N]" && read ans && [ $${ans:-N} = y ]
	@docker-compose down -v
	@rm -rf volume/
	@echo "✓ Cleanup complete"

ps:
	@docker-compose ps

shell-jenkins:
	@docker exec -it jenkins-instance /bin/bash

shell-nexus:
	@docker exec -it nexus-instance /bin/bash

shell-postgres:
	@docker exec -it postgres-instance /bin/sh

shell-sonarqube:
	@docker exec -it sonarqube-instance /bin/bash

shell-gitlab:
	@docker exec -it gitlab-instance /bin/bash
