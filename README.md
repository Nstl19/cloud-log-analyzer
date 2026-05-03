# cloud-log-analyzer
# LogSens – Cloud-Based Log Processing & Monitoring System

A cloud-based log ingestion and visualization system built on AWS, combining containerized services and event-driven serverless components.

---

## Live Demo

Live demo of frontend dashboard (Netlify-hosted UI connected to AWS backend):
**https://logsensloganalyzer.netlify.app/**

---

## Architecture and Flow

This architecture combines serverless event-driven components (Lambda, EventBridge) with a containerized backend deployed on EC2 for flexibility and control.

### Structure
<p align="center">
  <img src="Assets\CLA_struct.png" width="900">
</p>

## Features

The system is designed to efficiently generate, process, and visualize application logs in a scalable cloud environment:

* **Hybrid Cloud Architecture:** Combines AWS serverless services (Lambda, EventBridge, S3, DynamoDB, API Gateway) with a containerized backend deployed on EC2.
* **Containerized Backend:** Backend service is containerized using Docker and deployed on EC2 for controlled execution and scalability.
* **Automated Generation:** Logs are generated via Lambda triggered by EventBridge (cron-based scheduling).
* **Real-Time Processing:** S3 events trigger Lambda functions for near real-time log parsing and ingestion.
* **Structured Storage:** Logs are stored in DynamoDB for fast and scalable querying.
* **Interactive Dashboard:** Frontend built with HTML/CSS/JS enabling filtering, grouping, and real-time updates via API Gateway.
    * Collapsible daily log grouping
    * Severity-based filtering (INFO, WARN, ERROR)
    * Auto-refresh for live updates
* **Cost Optimization:** Scheduled cleanup removes logs older than 30 days using Lambda.
  
---

## Technologies Used

### Core Technologies

| Technology | Purpose |
| :--- | :--- |
| **Docker** | Containerization of backend service for consistent deployment on EC2 |
| **Terraform** | Infrastructure as Code (IaC) for provisioning and managing AWS resources |

---

### AWS Core Services

| Service | Purpose |
| :--- | :--- |
| **AWS Lambda** | Handles log generation, parsing, retrieval, and cleanup |
| **Amazon S3** | Stores raw logs before processing |
| **Amazon DynamoDB** | Stores structured log data |
| **Amazon API Gateway** | Provides REST API endpoints |
| **Amazon EventBridge** | Schedules log generation tasks |
| **AWS IAM** | Manages permissions securely using roles |
| **Amazon EC2** | Hosts the Dockerized backend service |

---

### Infrastructure & Frontend

| Component | Description |
| :--- | :--- |
| **Terraform** | Used for **Infrastructure as Code (IaC)** to deploy all AWS resources. |
| **Frontend** | Pure **HTML / CSS / JavaScript** for a fast, responsive interface. |
| **Hosting** | Hosted on **Netlify**. |
| **Frontend** | Vanilla HTML, CSS, and JavaScript for a lightweight, responsive interface |
| **Hosting** | Hosted on Netlify |

---

## Challenges & Learnings

- Debugged Docker deployment issues on EC2, including port binding conflicts and container lifecycle management  
- Transitioned from static AWS credentials to IAM roles, improving security and aligning with industry best practices  
- Resolved Terraform provisioning errors and managed infrastructure state effectively  
- Gained practical understanding of hybrid architectures combining serverless and container-based systems  

---

## Future Improvements

- Implement CI/CD pipeline using GitHub Actions for automated deployments  
- Integrate AWS CloudWatch for centralized logging and monitoring  
- Introduce reverse proxy (Nginx) for production-grade routing  
- Explore auto-scaling strategies for handling higher workloads  

---
