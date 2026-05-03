#!/bin/bash

if [ -f "tfplan" ]; then
  echo "Applying the terraform plan..."
  terraform apply -input=false "tfplan"
  
  if [ $? -eq 0 ]; then
    echo "Terraform apply completed successfully."
  else
    echo "Terraform apply failed." >&2
    exit 1
  fi
else
  echo "No plan file found, skipping apply."
fi
