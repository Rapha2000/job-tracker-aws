import base64
import json
import boto3
import uuid
from decimal import Decimal
from datetime import datetime

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("job_applications")


def lambda_handler(event, context):
    print("Event:", event)

    try:
        if event.get("isBase64Encoded", False):
            decoded_body = base64.b64decode(event.get("body", "")).decode("utf-8")
        else:
            decoded_body = event.get("body", "")

        print("Decoded body:", decoded_body)
        body = json.loads(decoded_body)

        job_id = body.get("job_id")
        user_id = body.get("user_id")

        if not user_id or not job_id:
            return {
                "statusCode": 400,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "Missing user_id or job_id"}),
            }

        # Construction de l'expression de mise à jour
        update_fields = [
            "company",
            "position",
            "status",
            "date_applied",
            "notes",
            "tags",
        ]
        expression_parts = []
        expression_values = {}
        expression_names = {}

        for field in update_fields:
            if field in body:
                placeholder_name = f"#{field}"  # e.g., #position
                placeholder_value = f":{field}"  # e.g., :position

                expression_parts.append(f"{placeholder_name} = {placeholder_value}")
                expression_values[placeholder_value] = body[field]
                expression_names[placeholder_name] = field  # map #position -> position

        if not expression_parts:
            return {
                "statusCode": 400,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"error": "No updatable fields provided"}),
            }

        # Exécution de la mise à jour
        table.update_item(
            Key={"user_id": user_id, "job_id": job_id},
            UpdateExpression="SET " + ", ".join(expression_parts),
            ExpressionAttributeValues=expression_values,
            ExpressionAttributeNames=expression_names,
        )

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"message": f"Application {job_id} updated"}),
        }

    except Exception as e:
        print("Error:", str(e))
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "Internal server error"}),
        }


# curl -X PUT "$(terraform output -raw api_base_url)/updateApplication" \
#   -H "Content-Type: application/json" \
#   -d '{
#     "user_id": "test-user",
#     "job_id": "9ced50f3-7007-426c-bb1f-b3c240a8aae4",
#     "company": "MistralAI",
#     "position": "MLOps Engineer"
#   }'
