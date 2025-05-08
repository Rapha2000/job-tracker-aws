#!/bin/bash
# bash script to test the createApplication endpoint after the terraform apply

set -euo pipefail

API_URL="$1"

echo "Sending request to: $API_URL/createApplication"

RESPONSE=$(curl --fail -s -X POST "$API_URL/createApplication" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "test-user",
    "company": "OpenAI",
    "position": "Software Engineer",
    "status": "applied",
    "date_applied": "2025-04-25T15:00:00Z",
    "notes": "Resume attached",
    "tags": ["AI", "priority"]
  }')

echo "Raw response:"
echo "$RESPONSE"

MESSAGE=$(echo "$RESPONSE" | jq -r '.message // empty')
USER_ID=$(echo "$RESPONSE" | jq -r '.application.user_id // empty')
JOB_ID=$(echo "$RESPONSE" | jq -r '.application.job_id // empty')

# Check minimal required fields
if [[ "$MESSAGE" != "Application created" ]]; then
  echo "Test failed: unexpected message"
  exit 1
fi

if [[ "$USER_ID" != "test-user" ]]; then
  echo "Test failed: unexpected user_id"
  exit 1
fi

if [[ -z "$JOB_ID" ]]; then
  echo "Test failed: missing job_id"
  exit 1
fi

echo "API test passed — application created successfully"