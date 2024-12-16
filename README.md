# Overview
This project involved the containerization and deployment of a full-stack yolo application using Docker.


# Requirements
Install the docker engine here:
- [Docker](https://docs.docker.com/engine/install/) 

## How to launch the application 


![Alt text](image.png)

## How to run the app
Use vagrant up --provison command
Yolo E-commerce Application
Project Overview
The Yolo e-commerce application is a full-stack project featuring a React frontend, a Node.js/Express backend, and MongoDB for the database. The application allows users to browse products and administrators to add new products through a dashboard interface.

Prerequisites
Docker
Docker Compose
Setup Instructions
Cloning the Repository
Fork the repository from GitHub.
Clone your forked repository to your local machine:
bash
Copy code
git clone https://github.com/<blackswanalpha>/yolo.git
cd yolo
Building and Running Containers using Docker Compose
Ensure Docker and Docker Compose are installed.
Build and run the containers:
bash
Copy code
docker-compose up -d
Usage
Accessing the Frontend and Backend
Frontend: Open your browser and navigate to http://localhost:3000.
Backend: Open your browser and navigate to http://localhost:5000.
Testing the Application
Add products through the frontend interface and verify their persistence in MongoDB.
Contributing
Fork the repository.
Create a new branch for your feature or bugfix:
bash
Copy code
git checkout -b feature/your-feature-name
Commit your changes with descriptive messages:
bash
Copy code
git commit -m "feat: Add new feature"
Push your branch and open a pull request.

commit 1: feat: Initialize repository with base project structure
commit 2: feat: Add Dockerfile for backend service
commit 3: feat: Add Dockerfile for frontend service
commit 4: feat: Set up docker-compose for multi-container application
commit 5: fix: Update environment variables in docker-compose.yml
commit 6: docs: Add setup instructions to README
commit 7: feat: Implement product addition feature in backend
commit 8: feat: Implement frontend UI for adding products
commit 9: chore: Add volume for MongoDB data persistence
commit 10: fix: Resolve port conflicts in docker-compose.yml

License
This project is licensed under the MIT License.
