# LogSens - A Cloud Log Analyzer 

A fully-serverless, real-time log ingestion and visualization system built on AWS. CLA provides a fast, interactive dashboard for monitoring automatically generated application logs, ensuring cost-efficiency and zero operational overhead.

---

## Live Demo

**https://logsensloganalyzer.netlify.app/**

---

## Architecture and Flow

The Cloud Log Analyzer is built entirely on **AWS Serverless services**, utilizing an event-driven design for maximum scalability and low cost.

### Structure

<img width="1102" height="510" alt="CLA_Structure" src="https://github.com/user-attachments/assets/c0cf869c-af24-4ad8-88c6-8ced655779ab" />


### High-Level Flow

1.  **Generation:** **AWS EventBridge** triggers the `cla_log_generator` Lambda function every minute to simulate application log creation.
2.  **Ingestion:** The generated log files are uploaded directly to an **S3 Bucket**.
3.  **Parsing:** The S3 upload event immediately triggers the `cla_parser` Lambda. This function reads, parses each line, and stores structured log entries in **DynamoDB**.
4.  **Visualization:** The modern frontend dashboard calls the `/logs` route on **API Gateway**.
5.  **Retrieval:** The API Gateway is backed by the `cla_fetch_logs` Lambda, which efficiently retrieves logs, grouped by date, from DynamoDB.
6.  **Maintenance:** A daily Lambda function handles **auto-cleanup**, removing log entries older than 30 days to maintain a lean database and control costs.

---

## Features

The Cloud Log Analyzer is designed for an optimal monitoring experience:

* **100% Serverless:** Built entirely on AWS Lambda, S3, DynamoDB, API Gateway, and EventBridge, ensuring **minimal operational cost** and maintenance.
* **Automated Generation:** Logs are automatically generated via a dedicated Lambda and EventBridge cron job for continuous data flow.
* **Real-Time Parsing:** Log ingestion and parsing are triggered instantly by **S3 events**, making the data available in near real-time.
* **Structured Storage:** All log entries are stored in **DynamoDB** for fast, scalable retrieval.
* **Interactive Dashboard:** A responsive frontend offering a beautiful UI with **glassmorphism** styling.
    * **Collapsible Daily Groups:** Easily manage and navigate logs by date.
    * **Level Filtering:** Filter logs by severity: **INFO**, **WARN**, and **ERROR**.
    * **Auto-Refresh:** Keeps the dashboard up-to-date with the latest log entries.
* **Cost Efficiency:** Built-in monthly auto-cleanup ensures logs older than 30 days are automatically removed, keeping storage costs low.

---

## Technologies Used

### AWS Core Services

| Service | Purpose |
| :--- | :--- |
| **AWS Lambda** | Core compute for log generation, parsing, fetching, and cleanup. |
| **Amazon S3** | Temporary storage for raw log files before parsing. |
| **Amazon DynamoDB** | Highly scalable NoSQL database for structured log storage. |
| **Amazon API Gateway** | Provides the REST API endpoint for the frontend to fetch logs. |
| **Amazon EventBridge** | Schedules the log generation task (cron job). |
| **AWS IAM** | Manages permissions between services. |

### Infrastructure & Frontend

| Component | Description |
| :--- | :--- |
| **Terraform** | Used for **Infrastructure as Code (IaC)** to deploy all AWS resources. |
| **Frontend** | Pure **HTML / CSS / JavaScript** for a fast, responsive interface. |
| **Hosting** | Hosted on **Netlify**. |

---

## Contribution

Feel free to open an issue or submit a pull request if you have any suggestions or bug fixes!

---

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
