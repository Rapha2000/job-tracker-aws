#!/bin/bash
# bash script to test the getApplications endpoint after the terraform apply

set -euo pipefail

API_URL="$1"

echo "Sending request to: $API_URL/applications"

RESPONSE=$(curl --fail -s -X GET "$API_URL/applications?user_id=test-user" \
  -H "Content-Type: application/json")

echo "Raw response:"
echo "$RESPONSE"

APPLICATIONS_COUNT=$(echo "$RESPONSE" | jq '.applications | length')
USER_ID=$(echo "$RESPONSE" | jq -r '.applications[0].user_id // empty')
COMPANY=$(echo "$RESPONSE" | jq -r '.applications[0].company // empty')

if [[ "$APPLICATIONS_COUNT" -eq 0 ]]; then
  echo "Test failed: no applications returned"
  exit 1
fi

if [[ "$USER_ID" != "test-user" ]]; then
  echo "Test failed: unexpected user_id in first application"
  exit 1
fi

if [[ "$COMPANY" != "OpenAI" ]]; then
  echo "Test failed: unexpected company in first application"
  exit 1
fi

echo "API test passed — applications retrieved successfully"

