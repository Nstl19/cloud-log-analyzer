from flask import Flask, jsonify
import boto3
import random
import datetime
import os

app = Flask(__name__)

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

def generate_logs():
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

    return file_name

@app.route("/generate-logs")
def generate():
    file_name = generate_logs()
    return jsonify({
        "status": "generated",
        "file": file_name
    })

@app.route("/health")
def health():
    return jsonify({"status": "ok"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)