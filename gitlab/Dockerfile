FROM gitlab/gitlab-ee:latest

# GitLab EE comes with most features enabled by default
# Additional configuration can be done via environment variables
# in docker-compose.yml

HEALTHCHECK --interval=10s --timeout=5s --start-period=60s --retries=5 \
  CMD curl -f http://localhost/ || exit 1
