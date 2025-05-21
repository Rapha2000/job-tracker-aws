# Variables
FRONTEND_DIR := ../frontend-client
ENV_FILE := $(FRONTEND_DIR)/.env
DIST_DIR := $(FRONTEND_DIR)/dist

# Step 1: Initialize and apply Terraform backend and frontend modules
.PHONY: apply
apply:
	@echo "Running terraform apply..."
	terraform apply -auto-approve

# Step 2: Generate .env from Terraform outputs
.env: apply
	@echo "Generating .env file from terraform outputs..."
	@echo "VITE_CLIENT_ID=$$(terraform output -raw cognito_client_id)" > $(ENV_FILE)
	@echo "VITE_API_URL=$$(terraform output -raw api_base_url)" >> $(ENV_FILE)
	@echo "VITE_REGION=$$(terraform output -raw aws_region)" >> $(ENV_FILE)

# Step 3: Build the React app
build: .env
	@echo "Building React frontend..."
	cd $(FRONTEND_DIR) && npm install && npm run build

# Step 4: Reapplying Terraform to update the frontend module with the new build
frontend: build
	@echo "Reapplying Terraform to update the frontend module with the new build..."
	terraform apply -auto-approve

# All steps
deploy: frontend
	@echo "Full deployment complete!"

# Clean local build and .env
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(DIST_DIR) $(ENV_FILE)
