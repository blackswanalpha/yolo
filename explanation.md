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