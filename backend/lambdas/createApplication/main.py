import base64
import json
import boto3
import uuid
from decimal import Decimal
from datetime import datetime

client = boto3.client('dynamodb')
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table('job_applications')
tableName = 'job_applications'

def lambda_handler(event, context):
    print(event)
    body = {}
    statusCode = 200
    headers = {
        "Content-Type": "application/json"
    }

    try:
        if event.get("isBase64Encoded", False):
            decoded_body = base64.b64decode(event.get("body", "")).decode("utf-8")
        else:
            decoded_body = event.get("body", "")

        print("Decoded body:", decoded_body)
        body = json.loads(decoded_body)

        print("Parsed body:", body)
        user_id = body.get('user_id') 
        if not user_id:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing user_id"})
            }
        
        job_id = str(uuid.uuid4())
        company = body.get('company', '')
        position = body.get('position', '')
        status = body.get('status', 'draft')
        date_applied = body.get('date_applied', datetime.utcnow().isoformat())
        notes = body.get('notes', '')
        tags = body.get('tags', [])

        item = {
            "user_id": user_id,
            "job_id": job_id,
            "company": company,
            "position": position,
            "status": status,
            "date_applied": date_applied,
            "notes": notes,
            "tags": tags
        }

        table.put_item(Item=item)

        return {
            "statusCode": 201,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({
                "message": "Application created",
                "application": item
            })
        }
    
    except Exception as e:
        print("Error:", str(e))
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "Internal server error"})
        }

    # body = "Hello from createApplication lambda function"
        
    # body = json.dumps(body)
    # res = {
    #     "statusCode": statusCode,
    #     "headers": {
    #         "Content-Type": "application/json"
    #     },
    #     "body": body
    # }
    # return res