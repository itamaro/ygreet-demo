#!/bin/bash
gcloud container builds submit --config cloudbuild.yaml .
PROJECT_ID="$(gcloud config get-value project 2>/dev/null)"
echo "Deploying app to GKE project $PROJECT_ID using kubectl default cluster"
sed 's/$PROJECT_ID/'$PROJECT_ID'/g' k8s-app.yaml | kubectl apply -f - --record
