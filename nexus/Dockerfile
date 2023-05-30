FROM sonatype/nexus3

# Set the Nexus version
ENV NEXUS_VERSION=3.54.1

# Install Ansible
RUN apt-get update && apt-get install -y ansible

# Copy Ansible playbook
COPY ./ansible /ansible

# Run Ansible playbook to configure Nexus
RUN ansible-playbook /ansible/playbook.yml
