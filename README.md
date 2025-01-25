
# Project: Automated E-commerce Deployment with Ansible and Terraform


1. **Stage 1**: Deployment using Ansible to configure and manage a Vagrant-provisioned Ubuntu server.
2. **Stage 2**: Integration of Terraform for infrastructure provisioning alongside Ansible for server configuration and application deployment.

## Features

- Automated deployment and configuration of the e-commerce platform.
- Containerization of application components using Docker.
- Integration of Ansible and Terraform to streamline resource provisioning and configuration.
- Role-based playbook structure for modularity and reusability.
- Persistent data storage for application functionality testing.



## Getting Started

### Prerequisites

- Install [Vagrant](https://www.vagrantup.com/).
- Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
- Install [Terraform](https://developer.hashicorp.com/terraform/downloads).
- Clone the repository:

```bash
git clone https://github.com/username/repository.git
```

### Stage 1: Ansible Instrumentation

1. **Provision the Vagrant VM**:

   ```bash
   cd stage-1
   vagrant up
   ```

2. **Run the Playbook**:

   ```bash
   ansible-playbook playbook.yml
   ```

3. **Verify Deployment**:

   Access the application in your browser at `http://localhost:8080`.

### Stage 2: Ansible and Terraform Instrumentation

1. **Switch to the `stage_two` branch**:

   ```bash
   git checkout stage_two
   ```

2. **Initialize and Apply Terraform**:

   ```bash
   cd stage-2/terraform
   terraform init
   terraform apply
   ```

3. **Run the Ansible Playbook**:

   ```bash
   cd ..
   ansible-playbook playbook.yml
   ```

4. **Verify Deployment**:

   Access the application as configured in the Terraform output.

## Commits Overview

Below is a summary of the 10 descriptive commits made during the development of this project:

1. **Initial Commit**:
   - Created repository and added `.gitignore` file.

2. **Added Vagrantfile**:
   - Configured Vagrant for provisioning Ubuntu 20.04 server.

3. **Ansible Playbook for Stage 1**:
   - Added main playbook and modular roles for frontend, backend, and database.

4. **Docker Configuration**:
   - Added tasks to deploy application components in Docker containers.

5. **Persistent Storage Setup**:
   - Configured persistent data volumes for application containers.

6. **README and Explanation Files**:
   - Created initial documentation for the project.

7. **Terraform Configuration for Stage 2**:
   - Added Terraform scripts for infrastructure provisioning.

8. **Integrated Ansible with Terraform**:
   - Updated playbook to trigger Terraform resource provisioning.

9. **Testing and Bug Fixes**:
   - Resolved configuration issues and ensured application runs successfully.

10. **Final Documentation**:
    - Updated README.md and explanation.md files with detailed instructions.

## Testing

- **Add Product Functionality**: Ensure products added via the form persist across sessions.
- **Browser Verification**: Verify that the e-commerce platform is accessible and functional.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgments

- Jeff Geerling for the Ubuntu 20.04 Vagrant box.
- Community resources for Ansible and Terraform integrations.




