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
<img width="1102" height="510" alt="CLA_Structure" src="https://github.com/user-attachments/assets/c0cf869c-af24-4ad8-88c6-8ced655779ab" />

## Features

The Cloud Log Analyzer is designed for an optimal monitoring experience:
The system is designed to efficiently generate, process, and visualize application logs in a scalable cloud environment:

* **Hybrid Cloud Architecture:** Combines AWS serverless services (Lambda, EventBridge, S3, DynamoDB, API Gateway) with a containerized backend deployed on EC2.
* **Containerized Backend:** Backend service is containerized using Docker and deployed on EC2 for controlled execution and scalability.
* **Automated Generation:** Logs are automatically generated via a dedicated Lambda and EventBridge cron job for continuous data flow.
* **Real-Time Parsing:** Log ingestion and parsing are triggered instantly by **S3 events**, making the data available in near real-time.
* **Structured Storage:** All log entries are stored in **DynamoDB** for fast, scalable retrieval.
* **Interactive Dashboard:** A responsive frontend offering a beautiful UI with **glassmorphism** styling.
* **Real-Time Parsing:** Log ingestion and parsing are triggered instantly by S3 events, making the data available in near real-time.
* **Structured Storage:** All log entries are stored in DynamoDB for fast, scalable retrieval.
* **Interactive Dashboard:** Frontend built with HTML/CSS/JS enabling log filtering, grouping, and real-time updates via API Gateway.
* **Collapsible Daily Groups:** Easily manage and navigate logs by date.
    * **Level Filtering:** Filter logs by severity: **INFO**, **WARN**, and **ERROR**.
    * **Level Filtering:** Filter logs by severity: INFO, WARN, and ERROR.
* **Auto-Refresh:** Keeps the dashboard up-to-date with the latest log entries.
* **Cost Efficiency:** Built-in monthly auto-cleanup ensures logs older than 30 days are automatically removed, keeping storage costs low.

* **Cost Optimization:** Automated cleanup using scheduled Lambda removes logs older than 30 days, reducing storage and DynamoDB costs.
  
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
| **AWS Lambda** | Core compute for log generation, parsing, fetching, and cleanup. |
| **Amazon S3** | Temporary storage for raw log files before parsing. |
| **Amazon DynamoDB** | Highly scalable NoSQL database for structured log storage. |
| **Amazon API Gateway** | Provides the REST API endpoint for the frontend to fetch logs. |
| **Amazon EventBridge** | Schedules the log generation task (cron job). |
| **AWS IAM** | Manages permissions between services. |
| **AWS Lambda** | Handles log generation, parsing, retrieval, and scheduled cleanup via multiple functions |
| **Amazon S3** | Temporary storage for raw log files before parsing |
| **Amazon DynamoDB** | Highly scalable NoSQL database for structured log storage |
| **Amazon API Gateway** | Provides REST API endpoints for frontend log retrieval |
| **Amazon EventBridge** | Schedules log generation tasks (cron-based triggers) |
| **AWS IAM** | Manages permissions using roles for secure service-to-service access |
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
