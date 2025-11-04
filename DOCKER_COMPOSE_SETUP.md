# 🎯 Complete Setup Guide - Fully Automated Docker Compose

## What's Been Set Up

Your CI/CD environment is now **fully automated** with Docker Compose. Everything is configured to start with a single command.

## ⚡ Quick Start

```bash
cd personal-cicd-server
./start.sh
```

That's it! The script will:
- ✅ Create all volume directories
- ✅ Build Docker images
- ✅ Start all services
- ✅ Wait for services to be healthy
- ✅ Display access information

## 🛠️ Services Included

### 1. **Jenkins** (CI/CD Orchestration)
- **Port:** 8080
- **URL:** http://localhost:8080
- **Status:** Auto-starts with health checks
- **Plugins Pre-configured:**
  - Git, Workflow, Docker, Credentials
  - SonarQube integration
  - GitLab integration

### 2. **Nexus** (Artifact Repository)
- **Port:** 8081
- **URL:** http://localhost:8081
- **Status:** Auto-starts
- **Data:** Persisted in `./volume/nexus/`

### 3. **SonarQube** (Code Quality)
- **Port:** 9000
- **URL:** http://localhost:9000
- **Default Credentials:** admin / admin
- **Database:** PostgreSQL (auto-managed)
- **Status:** Waits for PostgreSQL to be healthy

### 4. **GitLab** (Repository Management)
- **Port:** 80 (HTTP), 2222 (SSH)
- **URL:** http://localhost
- **Default Credentials:** root / gitlabadmin123
- **Edition:** Enterprise Edition

### 5. **PostgreSQL** (Database)
- **Port:** 5432
- **Purpose:** Backend for SonarQube
- **Status:** Auto-starts with health checks

## 📁 File Structure

```
personal-cicd-server/
├── docker-compose.yml       # Main orchestration (fully configured)
├── start.sh                 # Start all services (MAIN ENTRY POINT)
├── stop.sh                  # Stop services gracefully
├── status.sh                # Check service status
├── setup.sh                 # Initialize directories
├── Makefile                 # Convenient make commands
├── README.md                # Full documentation
├── jenkins/
│   ├── Dockerfile
│   └── plugins.txt          # Pre-configured plugins
├── nexus/
│   ├── Dockerfile
│   └── ansible/
├── sonarqube/
│   ├── Dockerfile
│   └── sonar.properties     # Configuration
├── gitlab/
│   └── Dockerfile
└── volume/                  # Auto-created - persistent data
    ├── jenkins/
    ├── nexus/
    ├── sonarqube/
    ├── postgres/
    └── gitlab/
```

## 🚀 Usage Commands

### Start Everything
```bash
./start.sh
```

### Check Status
```bash
./status.sh
# or
make status
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f jenkins
docker-compose logs -f sonarqube
docker-compose logs -f gitlab
```

### Stop Services
```bash
./stop.sh
# or
docker-compose stop
```

### Using Make (Optional)
```bash
make help           # Show all commands
make start          # Start services
make stop           # Stop services
make restart        # Restart services
make status         # Check status
make logs           # View logs
make clean          # Remove everything
```

## 🔐 Default Credentials

| Service | Username | Password | URL |
|---------|----------|----------|-----|
| Jenkins | - | *from container* | http://localhost:8080 |
| Nexus | admin | *from file* | http://localhost:8081 |
| SonarQube | admin | admin | http://localhost:9000 |
| GitLab | root | gitlabadmin123 | http://localhost |
| PostgreSQL | sonarqube | sonarqube_password | localhost:5432 |

**⚠️ Important:** Change all default passwords after first login!

## 💾 Data Persistence

All data is automatically persisted in `./volume/`:

- **Jenkins:** `./volume/jenkins/` - Jobs, configs, plugins
- **Nexus:** `./volume/nexus/` - Artifact repositories
- **SonarQube:** `./volume/sonarqube/` - Quality metrics, reports
- **PostgreSQL:** `./volume/postgres/` - SonarQube database
- **GitLab:** `./volume/gitlab/` - Repositories, users, configs

Data survives container restarts, stops, and removals!

## 🔄 How It Works

### 1. Volume Initialization
When `start.sh` runs, it creates all necessary directories:
```
volume/
├── jenkins/
├── nexus/
├── sonarqube/data
├── sonarqube/logs
├── sonarqube/extensions
├── postgres/
└── gitlab/config, data, logs
```

### 2. Image Building
Docker images are built from Dockerfiles:
- Jenkins: Pre-loads plugins from `plugins.txt`
- SonarQube: Applies config from `sonar.properties`
- Nexus: Builds from custom Dockerfile
- GitLab: Uses official Enterprise image
- PostgreSQL: Uses official Alpine image

### 3. Service Startup
Services start in dependency order:
1. PostgreSQL starts first
2. SonarQube waits for PostgreSQL to be healthy
3. Jenkins, Nexus, GitLab start in parallel
4. All services restart automatically on failure

### 4. Health Checks
Each service has health checks to verify it's ready:
- Jenkins: HTTP 200 on root endpoint
- SonarQube: API health check endpoint
- PostgreSQL: pg_isready command
- GitLab: Health endpoint check

## 🔧 Configuration

### Customize Services

Edit `docker-compose.yml` to:
- Change ports (e.g., 8080 → 8888)
- Modify environment variables
- Add additional volumes
- Change resource limits

### Update Jenkins Plugins

Edit `jenkins/plugins.txt`:
```
git
workflow-aggregator
docker-workflow
gitlab-plugin
sonar
# Add more as needed
```

Then rebuild:
```bash
docker-compose build jenkins
docker-compose up -d jenkins
```

### Update SonarQube Config

Edit `sonarqube/sonar.properties`:
```properties
sonar.security.realm=LDAP
sonar.search.javaOpts=-Xms512m -Xmx512m
# Modify as needed
```

## 🐛 Troubleshooting

### Services Won't Start
```bash
# Check logs
docker-compose logs -f

# Rebuild images
docker-compose build --no-cache

# Restart
docker-compose restart
```

### Can't Connect to Services
1. Wait 2-3 minutes for GitLab to start
2. Check ports aren't in use: `lsof -i :8080`
3. Verify Docker is running: `docker ps`
4. Check health: `docker-compose ps`

### Database Issues
```bash
# Restart PostgreSQL and SonarQube
docker-compose restart postgres sonarqube
```

### Reset Everything
```bash
docker-compose down -v
rm -rf volume/
./start.sh
```

## 📊 Monitoring

Check real-time service status:
```bash
./status.sh
```

Watch service logs:
```bash
docker-compose logs -f [service-name]
```

View container resource usage:
```bash
docker stats
```

## 🔗 Integration Setup

### Jenkins → GitLab
1. Go to Jenkins → Manage → Configure System
2. Add GitLab server: `http://gitlab-instance`
3. Create webhook in GitLab repository settings

### Jenkins → SonarQube
1. Install SonarQube Scanner plugin
2. Add SonarQube server: `http://sonarqube-instance:9000`
3. Configure in pipeline scripts

### Jenkins → Nexus
1. Configure repository URL: `http://nexus-instance:8081`
2. Add credentials for publishing

## 📝 Next Steps

1. **First Run:** `./start.sh`
2. **Access Services:** Open URLs in browser
3. **Change Passwords:** Update all default credentials
4. **Create Git Repositories:** Set up projects in GitLab
5. **Configure Jenkins Jobs:** Create CI/CD pipelines
6. **Set SonarQube Quality Gates:** Configure code quality rules

## 💡 Tips

- Keep `start.sh` to quickly spin up the full stack
- Use `make` commands for quick operations
- Monitor logs with `docker-compose logs -f`
- All data is safe in `./volume/` directory
- Commit `docker-compose.yml` to git for reproducibility
- Don't commit the `volume/` directory (add to `.gitignore`)

## 🆘 Support

For issues or questions:
1. Check logs: `./status.sh`
2. Restart services: `docker-compose restart`
3. Review docker-compose.yml configuration
4. Consult service-specific documentation

---

**Everything is now fully automated with Docker Compose!** 🎉
