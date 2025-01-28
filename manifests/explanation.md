# Detailed Explanation for Kubernetes Deployment on Google Kubernetes Engine (GKE)

## Project Overview

This project involves deploying a containerized application using Kubernetes on Google Kubernetes Engine (GKE). The application is composed of three main components: frontend, backend, and database services. The deployment incorporates StatefulSets for the database, persistent volumes for data storage, and LoadBalancer services to expose the application to internet traffic.

The goal of this project is to implement Kubernetes best practices, ensuring scalability, fault tolerance, and persistence.

---

## Explanation of Key Components

### 1. **Frontend Service**

The frontend service is a user-facing component of the application, typically a web-based UI. It is deployed using Kubernetes Deployments, which ensure high availability and scalability by maintaining the desired number of pod replicas.

- **Deployment Manifest**: The deployment YAML file defines the number of replicas, container image, and exposed ports. Example:

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: frontend
  spec:
    replicas: 3
    selector:
      matchLabels:
        app: frontend
    template:
      metadata:
        labels:
          app: frontend
      spec:
        containers:
        - name: frontend
          image: <your-frontend-image:tag>
          ports:
          - containerPort: 3000
  ```

- **Service**: A LoadBalancer service exposes the frontend pods to internet traffic. This enables external users to access the application through a publicly accessible IP address.

---

### 2. **Backend Service**

The backend service handles the business logic and acts as an intermediary between the frontend and the database. It is also deployed using Deployments for scalability and high availability.

- **Key Features**:

  - Stateless design ensures that pods can be replaced without affecting the application's functionality.
  - Exposes APIs for data manipulation and retrieval.

- **Manifest Structure**: Similar to the frontend, the backend deployment YAML specifies replicas, container image, and exposed ports.

---

### 3. **Database Service**

The database service uses PostgreSQL to store application data. A StatefulSet is used for deploying the database, ensuring that each pod maintains a unique identity and stable storage.

- **StatefulSet Benefits**:

  - Persistent storage ensures data durability even if the database pod is deleted.
  - Each replica has a stable network identity, which is crucial for applications requiring consistent storage.

- **Persistent Volumes**: PersistentVolume (PV) and PersistentVolumeClaim (PVC) are used to allocate storage to the database pods.

  Example PVC:

  ```yaml
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: db-storage
  spec:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 10Gi
  ```

---

## Deployment on GKE

### 1. **Cluster Creation**

A GKE cluster is created using the gcloud CLI. The cluster consists of three nodes and is located in the `us-central1-c` zone. Example command:

```bash
gcloud container clusters create io --zone us-central1-c --num-nodes=3
```

### 2. **Configuring kubectl**

The `kubectl` CLI is configured to communicate with the GKE cluster:

```bash
gcloud container clusters get-credentials io --zone us-central1-c
```

### 3. **Applying Manifests**

Kubernetes manifests (YAML files) for the frontend, backend, and database are applied using `kubectl`:

```bash
kubectl apply -f frontend.yaml
kubectl apply -f backend.yaml
kubectl apply -f statefulset.yaml
```

---

## Persistent Storage

Persistent storage is implemented for the database to ensure data durability. The deletion of the database pod does not result in data loss. This is achieved using PersistentVolume and PersistentVolumeClaim resources.

- **Verification**: Check the status of persistent volumes and claims:
  ```bash
  kubectl get pvc
  ```

---

## Exposing Services

### 1. **Frontend Exposure**

The frontend is exposed using a LoadBalancer service. Example manifest:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 3000
  selector:
    app: frontend
```

Retrieve the external IP address:

```bash
kubectl get service frontend-service
```

### 2. **Backend and Database Access**

Backend and database services use ClusterIP by default, restricting access to within the cluster. This ensures secure communication between application components.

---

## Git Workflow

### Steps Followed

1. **Initialize Repository**:
   ```bash
   git init
   ```
2. **Commit Changes**:
   ```bash
   git add .
   git commit -m "Initial Kubernetes deployment files"
   ```
3. **Push to GitHub**:
   ```bash
   git remote add origin <repo-url>
   git branch -M main
   git push -u origin main
   ```

---

## Testing and Debugging

### Verification Commands

- Check pod and service statuses:
  ```bash
  kubectl get pods
  kubectl get services
  ```
- View logs for debugging:
  ```bash
  kubectl logs <pod-name>
  ```

### Persistent Data Test

- Delete the database pod:
  ```bash
  kubectl delete pod <db-pod-name>
  ```
- Verify that data persists after the pod is recreated.

---

## Conclusion

This project demonstrates the deployment of a distributed application on GKE using Kubernetes best practices. Key highlights include:

- StatefulSet for managing database pods.
- Persistent storage for data durability.
- LoadBalancer services for exposing the application to the internet.

The successful implementation of this project showcases the robustness and scalability of Kubernetes as an orchestration platform.

