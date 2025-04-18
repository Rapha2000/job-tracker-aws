# JobTracker AWS

☁️ JobTracker AWS is a personal cloud-native project designed to track job applications through a lightweight and scalable web application. The goal is to demonstrate practical experience in modern cloud architecture and DevOps best practices using AWS serverless technologies.

---

## 🚀 Project Overview

This project simulates a real-world, production-grade cloud-native application with a clear technical and functional scope. It was built to showcase cloud solution design, Infrastructure as Code (IaC), and modern CI/CD practices, while also solving a personal need: managing job applications efficiently.

---

## 📌 Key Features

- REST API for job application tracking (CRUD)
- Serverless backend using AWS Lambda + API Gateway
- Data stored in DynamoDB (NoSQL)
- Secure endpoints (API key or Cognito-based auth)
- Infrastructure managed via Terraform
- CI/CD with GitHub Actions
- Logging and monitoring with CloudWatch

---

## 🔧 Tech Stack

| Layer            | Technology        |
|------------------|-------------------|
| Backend          | AWS Lambda (Python), API Gateway |
| Database         | DynamoDB          |
| Authentication   | Cognito at the end (but simple API key for MVP) |
| Infrastructure   | Terraform         |
| CI/CD            | GitHub Actions    |
| Monitoring       | CloudWatch Logs & Alarms |
| Frontend         | React + S3 + CloudFront |
| Bonus Features   | AWS SES, S3 file upload |

---

## 📐 Architecture

The application follows a modular, serverless architecture deployed entirely on AWS.  
A basic version includes:

[User] --> [API Gateway] --> [Lambda Functions] --> [DynamoDB]

More advanced components will include:

- Cognito for user authentication
- GitHub Actions pipeline for CI/CD
- CloudWatch alarms and dashboards
- S3 static frontend hosting

Detailed architecture diagrams are available in the `/diagrams` folder.

---

## 🛠️ Getting Started

> This project is currently in early development. The infrastructure setup and initial API endpoints will be released soon.

Planned modules:

1. **Infrastructure setup**: Terraform configuration for AWS resources
2. **API implementation**: Python-based Lambda functions for job application CRUD
3. **CI/CD integration**: Automated deployment pipelines with GitHub Actions
4. **Authentication**: Cognito user pool setup or basic API key usage
5. **Frontend / Demo**: static React frontend

---

## 📄 Documentation

- `README.md`: Project overview and progress
- `/infra`: All Terraform configuration files
- `/backend`: Lambda functions and tests
- `/diagrams`: Architecture diagrams and illustrations
- Future additions: Postman collection or OpenAPI spec for API

---

## 🧠 Skills Demonstrated

- Designing and documenting scalable cloud architectures
- Applying security best practices (IAM roles, access policies)
- Automating infrastructure with Terraform
- Implementing CI/CD with GitHub Actions
- Using monitoring/logging tools (CloudWatch)
- Clear and structured technical communication

---

## 📆 Project Timeline

| Phase                | Timeline        | Status        |
|----------------------|-----------------|---------------|
| Phase 0 – Setup      | April 2025      | ✅ In progress |
| Phase 1 – Backend MVP| May 2025        | ⏳ Planned     |
| Phase 2 – CI/CD/Auth | June 2025       | ⏳ Planned     |
| Phase 3 – Frontend   | July 2025       | ⏳ Planned     |
| Phase 4 – Polish     | Late July 2025  | ⏳ Planned     |

---

## 🙋‍♂️ Author

**Raphael** – Cloud/DevOps enthusiast with a generalist engineering background.  
Interested in solution architecture, cloud-native design, and scalable applications.  
This project was created as part of a personal portfolio to demonstrate applied cloud knowledge.




## 🔧 Tech Stack

- AWS Lambda (Python)
- API Gateway
- DynamoDB
- Terraform (IaC)
- GitHub Actions (CI/CD)

## 🎯 Objectives

- Demonstrate cloud architecture skills
- Deploy a serverless application, scalable and secure
- Structure and document the project 

## 🚧 Status

> Phase 0 - Initialization
> ✅ Repo initialized 
> 🔲 Terraform minimal 
> 🔲 Archi schema 
> 🔲 README complete
