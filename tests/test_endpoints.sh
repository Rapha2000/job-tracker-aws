#!/bin/bash

# Step 1: test the createApplication endpoint
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


# Step 2: test the getApplications endpoint
echo "Sending request to: $API_URL/applications"

RESPONSE=$(curl --fail -s -X GET "$API_URL/applications?user_id=test-user" \
  -H "Content-Type: application/json")

echo "Raw response:"
echo "$RESPONSE"

APPLICATIONS_COUNT=$(echo "$RESPONSE" | jq '.applications | length')
USER_ID=$(echo "$RESPONSE" | jq -r '.applications[0].user_id // empty')
COMPANY=$(echo "$RESPONSE" | jq -r '.applications[0].company // empty')
JOB_ID=$(echo "$RESPONSE" | jq -r '.applications[0].job_id // empty')

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


# Step 3a: test the updateApplication endpoint
echo "Sending request to: $API_URL/updateApplication"

RESPONSE=$(curl --fail -s -X PUT "$API_URL/updateApplication" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "test-user",
    "job_id": "'$JOB_ID'",
    "position": "ML Engineer",
    "company": "MistralAI",
  }')

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

EXPECTED_MSG="Application $JOB_ID updated"
ACTUAL_MSG=$(echo "$UPDATE_RESPONSE" | jq -r '.message // empty')

if [[ "$ACTUAL_MSG" != "$EXPECTED_MSG" ]]; then
  echo "Test failed: unexpected update message"
  echo "Expected: $EXPECTED_MSG"
  echo "Actual:   $ACTUAL_MSG"
  exit 1
fi

# Step 3b: verify the update by fetching the application again
VERIFY_RESPONSE=$(curl --fail -s -X GET "$API_URL/applications?user_id=test-user" \
  -H "Content-Type: application/json")

MATCHING_APP=$(echo "$VERIFY_RESPONSE" | jq --arg job_id "$JOB_ID" '.applications[] | select(.job_id == $job_id)')
NEW_COMPANY=$(echo "$MATCHING_APP" | jq -r '.company')
NEW_POSITION=$(echo "$MATCHING_APP" | jq -r '.position')

if [[ "$NEW_COMPANY" != "MistralAI" ]]; then
  echo "Test failed: company not updated"
  exit 1
fi

if [[ "$NEW_POSITION" != "ML Engineer" ]]; then
  echo "Test failed: position not updated"
  exit 1
fi

echo "API test passed — application updated and verified successfully"




