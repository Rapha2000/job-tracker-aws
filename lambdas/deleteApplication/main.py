import base64
import json
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("job_applications")


def lambda_handler(event, context):
    headers = {"Content-Type": "application/json"}

    try:
        if event.get("isBase64Encoded", False):
            decoded_body = base64.b64decode(event.get("body", "")).decode("utf-8")
        else:
            decoded_body = event.get("body", "")

        body = json.loads(decoded_body)

        user_id = body.get("user_id")
        job_id = body.get("job_id")

        if not user_id or not job_id:
            return {
                "statusCode": 400,
                "headers": headers,
                "body": json.dumps({"error": "Missing user_id or job_id"}),
            }

        try:
            table.delete_item(
                Key={"user_id": user_id, "job_id": job_id},
                ConditionExpression="attribute_exists(user_id) AND attribute_exists(job_id)",
            )
        except Exception as e:
            print("Error deleting item:", str(e))
            return {
                "statusCode": 400,
                "headers": headers,
                "body": json.dumps({"error": "Item not found or deletion failed"}),
            }

        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps(
                {"message": f"Application with job_id {job_id} deleted successfully."}
            ),
        }

    except Exception as e:
        print("Error:", str(e))
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({"error": "Internal server error"}),
        }


# curl -X POST "$(terraform output -raw api_base_url)/deleteApplication" \
#   -H "Content-Type: application/json" \
#   -d '{
#     "user_id": "test-user",
#     "job_id": "495077d2-5db4-41c5-9eba-4241562dbff5"
#   }'
