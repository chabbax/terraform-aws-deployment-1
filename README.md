# Example Infrastructure

## Architecture Diagram

The following infrastructure is applied to `dev` maintained in the AWS personal organisation, `staging` and `prod` environmenets in the AWS client account. The following infrastructure is `v1.0`. There are slight changes in resource specifications in each environement.

![Infrastrcture](docs/architecture.jpg)

## Overview

This repository contains the Terraform implementation for a secure, scalable, and event-driven AWS platform. The architecture supports client-facing API requests, secure file uploads through pre-signed URLs, asynchronous workflow processing using ECS Fargate containers, private service-to-service communication through VPC Lattice, and supporting data stores for analytics, metadata, caching, and application state.

The infrastructure is managed as code using Terraform, with reusable modules, environment-specific variables, and remote state management. The deployment workflow integrates with Bitbucket Pipelines and AWS CI/CD services to build, store, and deploy containerized workloads securely.

## Architecture Summary

The platform allows clients to authenticate through Amazon Cognito and interact with backend services through Amazon API Gateway.

File uploads are handled securely using Amazon S3 pre-signed URLs. After a file is uploaded, Amazon SQS queues the workflow request and decouples ingestion from backend processing.

Backend workloads run as containerized services on Amazon ECS with AWS Fargate inside private subnets. These services process workflows, generate recommendations, transform data, handle malware workflow processing, and interact with supporting data stores.

Internal service-to-service communication is handled through Amazon VPC Lattice using service networks, listeners, routing rules, service policies, and target groups.

Supporting data is stored in DynamoDB, ElastiCache Redis, and MongoDB/DocumentDB depending on the data type and access pattern. Lambda functions are used for lightweight API endpoints and error notification processing.

The full infrastructure is provisioned using Terraform and deployed through a CI/CD workflow using Bitbucket Pipelines, AWS CodePipeline, AWS CodeBuild, AWS CodeDeploy, and Amazon ECR.

## Key Features

- Infrastructure as Code using Terraform
- Secure client authentication using Amazon Cognito
- API request handling through Amazon API Gateway
- Secure file upload flow using S3 pre-signed URLs
- Asynchronous workflow processing using Amazon SQS
- Containerized workloads using Amazon ECS and AWS Fargate
- Private service-to-service communication using Amazon VPC Lattice
- Centralized container image storage using Amazon ECR
- CI/CD integration using Bitbucket Pipelines and AWS developer tools
- Distributed tracing using AWS X-Ray
- Configuration management using AWS Systems Manager Parameter Store
- DNS management using Amazon Route 53
- Caching using Amazon ElastiCache for Redis
- Metadata and workflow state storage using Amazon DynamoDB
- Analytics and document-style storage using MongoDB or Amazon DocumentDB
- Separation of public and private networking using VPC subnets

## AWS Technologies Used

| Technology                          | Purpose                                                                                             |
| ----------------------------------- | --------------------------------------------------------------------------------------------------- |
| Amazon VPC                          | Provides the isolated network boundary for the platform.                                            |
| Public Subnet                       | Hosts public-facing resources where controlled external access is required.                         |
| Private Subnet                      | Hosts ECS workloads, databases, cache layers, and internal services without direct public exposure. |
| Internet Gateway                    | Enables controlled internet connectivity for public-facing components.                              |
| Amazon API Gateway                  | Acts as the main entry point for client requests.                                                   |
| Amazon Cognito                      | Handles user registration, authentication, and authorization.                                       |
| Amazon S3                           | Stores uploaded files and application data.                                                         |
| S3 Pre-signed URLs                  | Allows temporary and secure file uploads without exposing AWS credentials.                          |
| Amazon SQS                          | Queues workflow requests and decouples upload events from processing services.                      |
| Amazon ECS                          | Runs containerized backend services and workflow processors.                                        |
| AWS Fargate                         | Provides serverless compute for ECS tasks without managing EC2 instances.                           |
| ECS Task Definitions                | Define container image, CPU, memory, environment variables, ports, and runtime configuration.       |
| Amazon ECR                          | Stores Docker container images used by ECS services.                                                |
| Amazon VPC Lattice                  | Provides secure private communication between internal services.                                    |
| VPC Lattice Service Network         | Groups internal services and enables controlled service discovery and communication.                |
| VPC Lattice Service Policy          | Controls which services and clients can communicate with each other.                                |
| VPC Lattice Listeners               | Receive internal service traffic.                                                                   |
| VPC Lattice Rules                   | Route traffic based on defined conditions.                                                          |
| VPC Lattice Target Groups           | Forward traffic to the correct backend service targets.                                             |
| AWS Lambda                          | Provides lightweight API endpoints and error notification processing.                               |
| Amazon DynamoDB                     | Stores structured metadata, workflow state, segmented data, and lookup data.                        |
| Amazon ElastiCache for Redis        | Provides low-latency caching for frequently accessed data.                                          |
| MongoDB / Amazon DocumentDB         | Stores document-style analytics and application data.                                               |
| AWS Systems Manager Parameter Store | Stores application configuration and environment-specific parameters.                               |
| AWS X-Ray                           | Provides distributed tracing for debugging and performance analysis.                                |
| Amazon Route 53                     | Manages DNS records and hosted zones for service endpoints.                                         |
| AWS CodePipeline                    | Orchestrates the application and infrastructure deployment workflow.                                |
| AWS CodeBuild                       | Builds, tests, and packages application code and container images.                                  |
| AWS CodeDeploy                      | Deploys application releases to target environments.                                                |
| AWS CodeCommit                      | Can be used as an AWS-hosted source repository or mirror.                                           |
| Bitbucket Pipelines                 | Triggers CI/CD workflows from the source repository.                                                |
| Terraform Cloud                     | Manages Terraform workspaces, state files, variables, and remote execution.                         |

## High-Level Workflow

1. Developers push code to Bitbucket.
2. Bitbucket Pipelines triggers the CI/CD workflow.
3. CodeBuild builds and tests the application.
4. Docker images are pushed to Amazon ECR.
5. CodePipeline and CodeDeploy manage deployment to ECS Fargate services.
6. Clients authenticate using Amazon Cognito.
7. Clients send requests through Amazon API Gateway.
8. Files are uploaded to Amazon S3 using pre-signed URLs.
9. S3 upload events trigger workflow messages in Amazon SQS.
10. ECS Fargate services consume workflow messages and process the workload.
11. Internal services communicate through Amazon VPC Lattice.
12. Processed data is stored in DynamoDB, ElastiCache Redis, and MongoDB/DocumentDB.
13. Lambda functions handle lightweight API and error notification workloads.
14. AWS X-Ray provides tracing and visibility across the request flow.

## Terraform Implementation

This repository is designed to provision the AWS infrastructure using Terraform.

The Terraform code can be structured using reusable modules for each major AWS service.
