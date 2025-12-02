import boto3
import json

def handler(event, context):
    dynamodb = boto3.client("dynamodb")

    resp = dynamodb.scan(TableName="CloudLogAnalyzer")
    items = resp.get("Items", [])

    grouped = {}

    for item in items:
        ts = item.get("timestamp", {}).get("S", "")

        if "_" in ts:
            base, _uniq = ts.split("_", 1)
        else:
            base = ts

        if " " in base:
            date, time = base.split(" ", 1)
        else:
            continue

        if date not in grouped:
            grouped[date] = []

        grouped[date].append({
            "time": time,
            "level": item.get("level", {}).get("S", ""),
            "message": item.get("message", {}).get("S", "")
        })

    for date in grouped:
        grouped[date].sort(key=lambda x: x["time"])

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps(grouped)
    }
