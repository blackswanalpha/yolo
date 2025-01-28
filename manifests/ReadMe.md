**README.md**

```markdown
# Kubernetes E-Commerce Deployment (Minikube)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Kubernetes implementation of an e-commerce application with persistent MongoDB storage, using StatefulSets and NodePort exposure. Designed for Minikube local development.

## Features
- MongoDB database with Persistent Volume
- StatefulSet for database stability
- Backend API deployment
- Frontend web interface
- Persistent cart data storage

## Prerequisites
- Minikube v1.25+
- kubectl v1.24+
- Docker 20.10+
- Helm (optional)

## File Structure
```
├── manifests/
│   ├── 00-namespace.yaml
│   ├── 01-mysql-statefulset.yaml
│   ├── 02-mysql-service.yaml
│   ├── 03-backend-deployment.yaml
│   ├── 04-backend-service.yaml
│   ├── 05-frontend-deployment.yaml
│   └── 06-frontend-service.yaml
├── Dockerfiles/
│   ├── backend.Dockerfile
│   └── frontend.Dockerfile
├── README.md
└── explanation.md
```

## Deployment

1. Start Minikube cluster:
   ```bash
   minikube start --driver=docker --memory=4096
   ```

2. Enable ingress addon:
   ```bash
   minikube addons enable ingress
   ```

3. Apply manifests:
   ```bash
   kubectl apply -f manifests/
   ```

4. Verify deployment:
   ```bash
   kubectl get all -n app-ns
   ```

## Access Application

Get frontend URL:
```bash
minikube service frontend-service -n app-ns --url
```

Sample output:
```
http://192.168.49.2:30007
```

## Example Commit History

1. `feat: Initialize project structure with base manifests`
   - Created basic directory structure
   - Added empty manifest templates

2. `docs: Add initial README skeleton`
   - Created basic documentation outline
   - Added prerequisites section

3. `feat: Add MongoDB StatefulSet with PVC template`
   - Implemented StatefulSet for database
   - Configured persistent volume claim

4. `feat: Create headless MongoDB service`
   - Added ClusterIP: None configuration
   - Defined port 3306 exposure

5. `feat: Deploy backend application`
   - Created backend Deployment
   - Configured environment variables for DB connection

6. `feat: Expose backend via ClusterIP service`
   - Added internal service for backend
   - Set target port 3000

7. `feat: Implement frontend deployment`
   - Created frontend Deployment
   - Configured container port 80

8. `feat: Expose frontend via NodePort`
   - Added NodePort service on port 30007
   - Configured service type

9. `docs: Add persistence explanation file`
   - Created explanation.md
   - Detailed StatefulSet choices

10. `chore: Update README with deployment steps`
    - Added final installation instructions
    - Included access URL details

## Persistent Storage Verification

1. Add items to cart through the UI
2. Delete database pod:
   ```bash
   kubectl delete pod mysql-0 -n app-ns
   ```
3. New pod will automatically restart
4. Verify cart items persist after pod recreation

## License
This project is licensed under the [MIT License](LICENSE).

## Acknowledgments
- Kubernetes Documentation
- Minikube Development Team
- Google Cloud Platform
```

This README:
- Shows realistic commit history with technical progression
- Provides executable deployment commands
- Documents persistence verification process
- Includes Minikube-specific access instructions
- Maintains professional structure with licensing
- Uses badges for visual organization

The commit history demonstrates:
1. Feature implementation sequence
2. Documentation updates
3. Progressive refinement of components
4. Atomic changes for easy rollback
5. Conventional commit message style