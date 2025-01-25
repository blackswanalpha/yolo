

### Stage 1: Ansible Instrumentation

This stage focuses on configuring an automated deployment pipeline using **Ansible** to set up and deploy a containerized e-commerce platform on a Vagrant-provisioned virtual machine. Below is a breakdown of the required tasks and their implementation.

---

#### 1. **Provisioning the Virtual Machine**

- Use the **Jeff Geerling's Ubuntu 20.04** Vagrant box as the base image.
- The `Vagrantfile` is configured to:
  - Set up a virtual machine with the latest Ubuntu Server.
  - Assign network forwarding for port `8080` (mapped to the host for browser testing).

**Vagrantfile Example:**
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/ubuntu2004"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end
end
```

---

#### 2. **Defining the Ansible Playbook**

The playbook is the main file that orchestrates the configuration and deployment tasks. It includes:
- **Roles** for modular task implementation.
- **Variables** for flexibility and parameterization.
- **Tags** for task categorization.
- **Blocks** for structured task execution and error handling.

**Sample Playbook Structure:**
```yaml
---
- name: Deploy E-commerce Platform
  hosts: all
  become: yes
  vars_files:
    - vars/common.yml

  tasks:
    - name: Set up the application
      block:
        - name: Install dependencies
          ansible.builtin.apt:
            name: "{{ item }}"
            state: present
          loop: "{{ dependencies }}"
          tags: dependencies

        - name: Clone GitHub repository
          ansible.builtin.git:
            repo: https://github.com/username/repository.git
            dest: /var/www/ecommerce
          tags: setup

    roles:
      - frontend
      - backend
      - database
```

---

#### 3. **Implementing Roles**

Each application component (frontend, backend, database) is implemented in separate **roles** for modularity. 

**Role Example: Frontend**

```
roles/frontend/
├── tasks/main.yml
├── 
└── vars/main.yml
```

**Sample Task:**
```yaml
- name: Set up Frontend Docker Container
  ansible.builtin.docker_container:
    name: frontend
    image: frontend-image:latest
    ports:
      - "3000:3000"
```

---

#### 4. **Containerization Tasks**

In the playbook, define the tasks for deploying each component into Docker containers:
- **Frontend**: Serves the web application UI.
- **Backend**: Handles API and business logic.
- **Database**: Stores product and user data.

**Sample Container Task for Backend:**
```yaml
- name: Set up Backend Docker Container
  ansible.builtin.docker_container:
    name: backend
    image: backend-image:latest
    ports:
      - "5000:5000"
    env:
      DATABASE_URL: "postgresql://user:password@database:5432/dbname"
```

---

#### 5. **Using Variables**

Variables are stored in `vars/common.yml` for global reuse.

**Example Variables:**
```yaml
dependencies:
  - docker
  - docker-compose

frontend_port: 3000
backend_port: 5000
database_port: 5432
```

---

#### 6. **Cloning and Running the Application**

Tasks to:
1. Clone the application repository from GitHub.
2. Build and start Docker containers.
3. Validate the deployment with browser access.

**Task Example:**
```yaml
- name: Clone repository
  ansible.builtin.git:
    repo: "https://github.com/username/ecommerce-app.git"
    dest: "/var/www/ecommerce"

- name: Start all containers
  ansible.builtin.command:
    cmd: "docker-compose up -d"
    chdir: "/var/www/ecommerce"
```

---

#### 7. **Verification**

Once the playbook runs successfully:
1. Open your browser at `http://localhost:8080`.
2. Test the **Add Product** functionality.

---

