#!/bin/bash

# Variables
AWS_REGION="us-west-2"
REPOSITORY_NAME="my-repo"
IMAGE_NAME="my-app"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Step 1: Create ECR repository
aws ecr create-repository --repository-name $REPOSITORY_NAME --region $AWS_REGION

# Step 2: Authenticate Docker to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# Step 3: Build Docker image
docker build -t $IMAGE_NAME .

# Step 4: Tag Docker image
docker tag $IMAGE_NAME:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPOSITORY_NAME}:latest

# Step 5: Push Docker image to ECR
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPOSITORY_NAME}:latest

# Step 6: Pull Docker image from ECR
docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPOSITORY_NAME}:latest