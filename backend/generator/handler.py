import boto3
import random
import datetime
import os

s3 = boto3.client('s3')

BUCKET = os.environ.get("BUCKET_NAME")

LEVELS = ["INFO", "WARN", "ERROR"]
MESSAGES = {
    "INFO": [
        "Service started",
        "User logged in",
        "Health check OK",
        "Background job completed"
    ],
    "WARN": [
        "High memory usage",
        "Slow API response detected",
        "Cache nearing capacity"
    ],
    "ERROR": [
        "Database connection failed",
        "Timeout contacting service",
        "Internal server exception"
    ]
}

def handler(event, context):
    now = datetime.datetime.utcnow()
    timestamp = now.strftime("%Y-%m-%d %H:%M:%S")

    lines = []
    for _ in range(3):
        level = random.choice(LEVELS)
        msg = random.choice(MESSAGES[level])
        lines.append(f"{timestamp} {level} {msg}")

    log_data = "\n".join(lines)

    file_name = now.strftime("auto-%Y-%m-%d-%H-%M.log")

    s3.put_object(
        Bucket=BUCKET,
        Key=f"logs/{file_name}",
        Body=log_data.encode("utf-8")
    )

    return {"status": "generated", "file": file_name}
