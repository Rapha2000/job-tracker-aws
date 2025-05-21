# JobTracker AWS

☁️ JobTracker AWS is a personal cloud-native project designed to track job applications through a lightweight and scalable web application. The goal is to demonstrate practical experience in modern cloud architecture and DevOps best practices using AWS serverless technologies.

---

## 🚀 Project Overview

This project simulates a real-world, production-grade cloud-native application with a clear technical and functional scope. It was built to showcase cloud solution design, Infrastructure as Code (IaC), and CI/CD practices, while also solving a personal need: managing job applications efficiently.

---

## 📌 Key Features

- REST API for job application tracking (CRUD)
- Serverless backend with AWS Lambda and API Gateway
- Data stored in DynamoDB (NoSQL)
- Secure endpoints via Cognito authentication
- Infrastructure managed using Terraform
- CI/CD pipelines with GitHub Actions
- Logging and monitoring through CloudWatch

---

## 🔧 Tech Stack

| Layer            | Technology        |
|------------------|-------------------|
| Backend          | Lambda (Python), API Gateway |
| Database         | DynamoDB                     |
| Authentication   | Cognito                      |
| Infrastructure   | Terraform                    |
| CI/CD            | GitHub Actions               |
| Monitoring       | CloudWatch Logs & Alarms     |
| Frontend         | React + S3 + CloudFront      |
| Bonus Features   | AI workflow integrations     |

---

## 📐 Architecture

The application follows a modular, serverless architecture deployed entirely on AWS.  
A basic version includes:

[User] --> [API Gateway] --> [Lambda Functions] --> [DynamoDB]

Additional components:

- AWS Cognito for user authentication
- GitHub Actions for CI/CD
- CloudWatch for monitoring and alarms
- Static frontend hosted on S3 and served through CloudFront
- Detailed architecture diagrams are available in the /diagrams folder.

---

## 🛠️ Getting Started

> This project is currently under development.

Planned modules:

1. **Infrastructure setup**: Terraform configuration for AWS resources
2. **API implementation**: Python-based Lambda functions for job application CRUD
3. **CI/CD integration**: Automated deployment pipelines with GitHub Actions
4. **Authentication**: Cognito user pool setup
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

| Phase                 | Timeline        | Status         |
|-----------------------|-----------------|----------------|
| Phase 0 – Setup       | April 2025      | ✅ Done        |
| Phase 1 – Backend MVP | May 2025        | ✅ Done        |
| Phase 2 – CI/CD & Auth| May 2025        | ✅ Done        |
| Phase 3 – Frontend    | May 2025        | ✅ Done        |
| Phase 4 – Polish      | June 2025       | 🚧 In Progress |

---

## 🙋‍♂️ Author

**Raphael** – Cloud/DevOps/AI enthusiast with a generalist engineering background.  
Interested in solution architecture, cloud-native design, and scalable applications.  
This project was created as part of a personal portfolio to demonstrate applied cloud knowledge.


## 🔧 Tech Stack

- AWS Lambda (Python)
- AWS API Gateway
- AWS DynamoDB
- AWS Cognito
- Static Website Hosting using AWS S3 & CloudFront
- Terraform (IaC)
- GitHub Actions (CI/CD)

## 🎯 Objectives

- Demonstrate cloud architecture skills
- Deploy a serverless application, scalable and secure
- Structure and document the project 

## 🚧 Status

> Phase 0 - Initialization

> Repo initialized ✅
> Terraform minimal ✅
> Architecture schema completed ✅ 
> README completed ✅

> Phase 1 - Backend MVP

> Lambda endpoints (CRUD, 4/4) ✅ 
> DynamoDB setup ✅
> API Gateway REST (4/4 endpoints) ✅
> Curl tests (4/4) ✅ 
> Full Terraform deployment ✅
> CloudWatch logs ✅

> Phase 2 - CI/CD & Auth

> GitHub Actions: Lambda/API deployment and tests ✅ 
> Added security with Cognito ✅ 
> Basic CloudWatch alarms 🔲

> Phase 3 - Frontend

> Minimal React frontend (form + table) ✅  
> Static website deployed on S3 + CloudFront ✅ 
> Basic CloudWatch alarms 🔲 

## Resources

- [Didacticiel : création d’une API HTTP CRUD avec Lambda et DynamoDB](https://docs.aws.amazon.com/fr_fr/apigateway/latest/developerguide/http-api-dynamo-db.html#http-api-dynamo-db-create-function)
- [https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway](https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway)
- [About continuous integration with GitHub Actions](https://docs.github.com/en/actions/about-github-actions/about-continuous-integration-with-github-actions)
- [AWS HTTP Api Gateway with Cognito and Terraform](https://andrewtarry.com/posts/aws-http-gateway-with-cognito-and-terraform/)
- [Set up an example React single page application](https://docs.aws.amazon.com/cognito/latest/developerguide/getting-started-user-pools-application-other-options.html)
- [CloudFront custom error responses](https://medium.com/@codenova/deploy-a-react-application-on-aws-with-cloudfront-and-s3-6e65333d4610)

