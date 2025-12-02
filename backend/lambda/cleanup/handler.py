import boto3
from datetime import datetime, timedelta

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("CloudLogAnalyzer")

def handler(event, context):

    cutoff = datetime.utcnow() - timedelta(days=30)
    cutoff_str = cutoff.strftime("%Y-%m-%d")

    print(f"Deleting logs older than: {cutoff_str}")

    response = table.scan(
        ProjectionExpression="#ts, id",
        ExpressionAttributeNames={
            "#ts": "timestamp"
        }
    )

    items = response.get("Items", [])
    print(f"Scanned {len(items)} items")

    deleted = 0

    for item in items:
        ts = item.get("timestamp", "")


        log_date = ts.split("_")[0]

        if log_date < cutoff_str:
            print("Deleting:", item["id"], ts)
            table.delete_item(
                Key={
                    "id": item["id"],
                    "timestamp": item["timestamp"]
                }
            )
            deleted += 1

    print(f"Cleanup complete. Deleted {deleted} old logs.")

    return {
        "status": "ok",
        "deleted": deleted
    }
