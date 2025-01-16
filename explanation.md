# Explanation of Docker Setup for E-commerce Application

## 1. Choice of Base Image

### Backend
For the backend, we chose the official Node.js image (`node:14`). This image is well-suited for running Node.js applications and includes all necessary dependencies to run the server. We selected version 14 as it is a stable and widely supported LTS version, ensuring compatibility and long-term support.

### Frontend
For the frontend, we used a multi-stage build process:
1. **Build Stage**: We used the official Node.js image (`node:14`) to install dependencies and build the React application.
2. **Production Stage**: We used the `nginx:alpine` image to serve the built static files. The Alpine version of Nginx is lightweight and efficient, reducing the overall image size.

### MongoDB
For the database, we chose the official MongoDB image (`mongo:latest`). This image is optimized for running MongoDB and includes all necessary configurations to ensure a reliable database service.

## 2. Dockerfile Directives

### Backend Dockerfile
```dockerfile
# Use the official Node.js image as a base
FROM node:14

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 5000

# Start the application
CMD ["npm", "start"]
FROM node:14: Specifies the base image.
WORKDIR /app: Sets the working directory inside the container.
*COPY package.json ./**: Copies package.json and package-lock.json to the container.
RUN npm install: Installs dependencies.
COPY . .: Copies the rest of the application code.
EXPOSE 5000: Exposes port 5000 for the backend.
CMD ["npm", "start"]: Runs the application.
Frontend Dockerfile
dockerfile
Copy code
# Use the official Node.js image as a base
FROM node:14

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Use a simple web server to serve the built React app
FROM nginx:alpine
COPY --from=0 /app/build /usr/share/nginx/html

# Expose the port the app runs on
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
FROM node:14: Specifies the base image for building the React app.
WORKDIR /app: Sets the working directory inside the container.
*COPY package.json ./**: Copies package.json and package-lock.json to the container.
RUN npm install: Installs dependencies.
COPY . .: Copies the rest of the application code.
RUN npm run build: Builds the React application.
FROM nginx:alpine: Specifies the Nginx image for serving the built files.
COPY --from=0 /app/build /usr/share/nginx/html: Copies built files from the build stage.
EXPOSE 80: Exposes port 80 for the frontend.
CMD ["nginx", "-g", "daemon off;"]: Runs Nginx.
3. Docker-Compose Networking
Docker Compose sets up a bridge network to enable communication between containers. The app-network is a custom bridge network that allows the backend, frontend, and MongoDB containers to communicate with each other.

Example:
yaml
Copy code
networks:
  app-network:
    driver: bridge
4. Docker-Compose Volume Definition and Usage
Volumes are used to persist data and share it between the host and containers. In this setup, we define a volume for MongoDB data to ensure data persistence across container restarts.

Example:
yaml
Copy code
volumes:
  mongo-data:
5. Git Workflow
We followed a structured Git workflow to manage our project:

Feature Branches: Created feature branches for different parts of the project (e.g., feature/backend, feature/frontend).
Commits: Made descriptive commits for each significant change, ensuring at least 10 commits for proper tracking.
Pull Requests: Opened pull requests for code review before merging to the main branch.
Tagging: Used semantic versioning (semver) for image tagging (e.g., v1.0.0, v1.0.1).
6. Successful Running of the Application
To verify the application runs successfully, use Docker Compose:

bash
Copy code
docker-compose up -d
Check the frontend at http://localhost:3000.
Check the backend at http://localhost:5000.
If issues arise, use docker-compose logs to debug.

7. Best Practices
Image Tagging: Used semver for tagging images (e.g., yourdockerhubusername/yolo-backend:v1.0.0).
Documentation: Maintained a well-documented README.md for setup instructions.
Security: Ensured no sensitive data is exposed in the Dockerfiles or Compose files.
8. DockerHub Deployment
We pushed the built images to DockerHub for easy access:

bash
Copy code
docker build -t yourdockerhubusername/yolo-backend:v1.0.0 ./backend
docker build -t yourdockerhubusername/yolo-frontend:v1.0.0 ./client
docker push yourdockerhubusername/yolo-backend:v1.0.0
docker push yourdockerhubusername/yolo-frontend:v1.0.0
Screenshot: Link to DockerHub Screenshot
Submission
GitHub Repository Link



To further detail the **Stage 1: Ansible Instrumentation**, here's how you can implement and explain the required steps:

---

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

### **Stage 2: Ansible and Terraform Instrumentation**

#### **Step 1: Setup Stage 2**
1. **Create a New Branch**:
   
bash
   git checkout -b Stage_two


2. **Create a New Directory**:
   
bash
   mkdir stage-2-terraform && cd stage-2-terraform


---

#### **Step 2: Create Terraform Scripts**
1. **Install Terraform**:
   - Download Terraform from [terraform.io](https://www.terraform.io/downloads) and install it.

2. **Set Up the Terraform File Structure**:
   - Create a main.tf file:
     
hcl
     provider "virtualbox" {}

     resource "virtualbox_vm" "ansible_vm" {
       name = "AnsibleVM"
       image = "ubuntu/focal64"
       cpus = 2
       memory = 2048
     }

     output "vm_ip" {
       value = "192.168.56.101"
     }


3. **Provision Resources**:
   - Initialize and apply Terraform:
     
bash
     terraform init
     terraform apply -auto-approve


---

#### **Step 3: Integrate Ansible with Terraform**
1. **Modify the Playbook to Use Terraform Outputs**:
   - Update ansible/inventory dynamically using Terraform's output:
     
bash
     terraform output -raw vm_ip > ansible/inventory


2. **Trigger Ansible from Terraform**:
   - In main.tf, use the local-exec provisioner:
     
hcl
     provisioner "local-exec" {
       command = "ansible-playbook -i ../ansible/inventory ../ansible/main.yml"
     }


3. **Reapply Terraform**:
   
bash
   terraform apply -auto-approve


---

#### **Step 4: Test and Verify**
1. **Check the Application**:
   - Visit http://<Terraform-provisioned-IP> in your browser.
   - Test the "Add Product" feature for data persistence.

---

### **Final Steps: Document and Submit**
1. **Write README.md**:
   - Include setup instructions for both stages.

2. **Write explanation.md**:
   - Describe:
     - The roles and modules used in Ansible.
     - Terraform configurations and their purpose.
     - The integration process.

3. **Push to GitHub**:
   
bash
   git add .
   git commit -m "Complete Stage 1 and Stage 2 setup"
   git push origin Stage_two


4. **Submit the Repository Link**:
   - Ensure all files (Vagrantfile, main.yml, Terraform scripts, etc.) are included.