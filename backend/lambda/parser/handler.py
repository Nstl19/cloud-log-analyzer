import boto3
import uuid
import os

BUCKET = os.environ["BUCKET_NAME"]

def handler(event, context):
    s3 = boto3.client("s3")
    dynamodb = boto3.client("dynamodb")

    record = event["Records"][0]
    bucket = record["s3"]["bucket"]["name"]
    key = record["s3"]["object"]["key"]

    if bucket != BUCKET:
        print("Skipping unwanted bucket:", bucket)
        return {"status": "ignored"}

    obj = s3.get_object(Bucket=bucket, Key=key)
    content = obj["Body"].read().decode("utf-8", errors="replace")

    print("FILE CONTENT BEGIN")
    print(content)
    print("FILE CONTENT END")

    for line in content.splitlines():
        raw = line.strip()
        if not raw:
            continue

        parts = raw.split(" ")

        if len(parts) < 3:
            print("Skipping invalid:", raw)
            continue

        # Timestamp extraction
        date = parts[0]
        time = parts[1]
        full_timestamp = f"{date} {time}"

        level = parts[2]
        message = " ".join(parts[3:])

        # Unique sort key to prevent overwrites
        unique_ts = f"{full_timestamp}_{uuid.uuid4().hex[:6]}"

        dynamodb.put_item(
            TableName="CloudLogAnalyzer",
            Item={
                "id": {"S": key},
                "timestamp": {"S": unique_ts},
                "level": {"S": level},
                "message": {"S": message}
            }
        )

    return {"status": "ok"}
