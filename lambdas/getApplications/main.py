import json
import boto3
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("job_applications")


def lambda_handler(event, context):
    print(event)
    headers = {"Content-Type": "application/json"}

    try:
        user_id = event.get("queryStringParameters", {}).get("user_id")

        if not user_id:
            return {
                "statusCode": 400,
                "headers": headers,
                "body": json.dumps({"error": "Missing user_id"}),
            }

        # Fetch applications for the user
        response = table.query(KeyConditionExpression=Key("user_id").eq(user_id))

        applications = response.get("Items", [])

        if not applications:
            return {
                "statusCode": 404,
                "headers": headers,
                "body": json.dumps({"message": "No applications found for this user"}),
            }

        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({"applications": applications}),
        }

    except Exception as e:
        print("Error:", str(e))
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"error": "Internal server error"}),
        }


# curl -X GET "$(terraform output -raw api_base_url)/applications?user_id=test-user" \
#   -H "Content-Type: application/json"
