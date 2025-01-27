# Kubernetes Deployment Explanation

## 1. Kubernetes Objects & Design Choices

### StatefulSet for MySQL
- **Why StatefulSet?**  
  StatefulSets were chosen for the MySQL database to ensure:
  - **Stable Network Identity**: Pods get predictable names (`mysql-0`, `mysql-1`, etc.) and DNS entries (`mysql-0.mysql-service.app-ns.svc.cluster.local`).  
  - **Persistent Storage**: Data survives pod restarts/rescheduling via `volumeClaimTemplate`.  
  - **Orderly Deployment**: Critical for clustered databases (though only 1 replica is used here for simplicity).  

- **Alternatives Considered**:  
  A `Deployment` with a `PersistentVolume` would work for single-replica databases but lacks stable DNS, which is crucial for applications relying on consistent database endpoints.

---

### Services for Exposure
- **MySQL Service (Headless)**  
  - `clusterIP: None` creates a headless service, returning direct pod IPs instead of a virtual IP.  
  - Used by the backend to connect to the database pod via DNS: `mysql-service.app-ns.svc.cluster.local`.  

- **Frontend Service (NodePort)**  
  - Exposes the frontend on a static port (`30007`) on all Minikube nodes.  
  - Accessible via `minikube service frontend-service --url`.  

- **Backend Service (ClusterIP)**  
  - Internal-only communication. The frontend connects to the backend via this service at `backend-service.app-ns.svc.cluster.local:3000`.  

---

### Persistent Storage
- **Implementation**:  
  ```yaml
  volumeClaimTemplates:
    - metadata: { name: mysql-persistent-storage }
      spec:
        accessModes: [ "ReadWriteOnce" ]
        resources: { requests: { storage: 1Gi } }