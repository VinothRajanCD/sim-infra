SIM Gamification Infrastructure Setup

# sim-gamification-infra-setup

AWS Infrastructure setup for UQ Chloe

# Directories

Description                                                                                           
|-------------------|----------------------------------------------------------------------------
| `env`     | Code to build the Infrastructure for Staging, UAT, Production, and Admin services environments.

| `admin`   | Code to build Jenkins Server Setup.

| `staging` | Code to build SIM Gamification Staging env Setup.

| `production` | Code to build SIM Gamification Production env Setup.

| `modules` | It contains the AWS resources script, and the script is more generic.

-------------------------------------------------------------------------------------------------
|-------------------|

# Getting started

1. Configure the AWS credentials in your local environment.

```
aws configure --profile #profile_name (It can be anything)
AWS Access Key ID [None]: #paste your AWS access key
AWS Secret Access Key [None]: #paste your secret access key
Default region name [None]: #Enter the region name that you want to create the environment. (eg: ap-southeast-2)
Default output format [None]: #ENter the output format that you want to return. (eg: json)

```
2. Export the AWS Profile that you created in step 1.

```
export AWS_PROFILE=#profile_name

```

3. Lets deploy the Infrastructure
  
  a. Initialise the terraform in your environment

      $ terraform init

  b. Check whether the configuration is valid

      $ terraform validate 

  c. Show changes required by the current configuration

      $ terraform plan

  d. Create or update infrastructure       

      $ terraform apply

4. We have the option to deploy the specific AWS resources to specific modules by using the below commands 

```
(a). Now, let us create a plan for the VPC (Virtual Private Cloud) stack

$ terraform plan -target=module.vpc

Once you are satisfied with your service, deploy the scripts by running the apply command.

$ terraform apply -target=module.vpc

(Or) If you want to create a specific service inside the module, run the below command.

$ terraform plan -target=module.aws_vpc.main (point the resource name in the module)

It will again list the services that you are going to create and it will ask for user confirmation. you need to enter [Yes] to deploy the terraform scripts.


(b). Now, let's create a plan for the Security stack.

$ terraform plan -target=module.security

Once you are satisfied with your service deploy the scripts by running the apply command.

$ terraform apply -target=module.security

(c). Now, let's create a plan for the ACM (AWS Certificate Manager) stack 

$ terraform plan -target=module.acm

Once you reviewed the plan let's deploy,

$ terraform apply -target=module.acm

(d). Now, let's create a plan for the ALB (Application Load Balancer) stack and deploy it after reviewing the plan.

$ terraform plan -target=module.alb

Once you reviewed the plan let's deploy,

$ terraform apply -target=module.alb

(e). Now, let's create a plan for the ECR (Elastic Container Registry) stack and deploy it after reviewing the plan.

$ terraform plan -target=module.ecr

Once you reviewed the plan let's deploy

$ terraform apply -target=module.ecr

(f). Now, let's create a plan for the Secret Manager stack and deploy it after reviewing the plan.

$ terraform plan -target=module.secret_manager

Once you reviewed the plan let's deploy,

$ terraform apply -target=module.secret_manager

(g). Now, let's create a plan for the IAM (Identity Access Management) stack and deploy it after reviewing the plan.

$ terraform plan -target=module.iam

Once you reviewed the plan let's deploy,

$ terraform apply -target=module.iam

(h). Now, let's create a plan for the KMS (Key Management Service) stack and deploy it after reviewing the plan.

$ terraform plan -target=module.kms

Once you reviewed the plan let's deploy,

$ terraform apply -target=module.kms

(i). Now, let's create a plan for the RDS (Relational Database Service) stack and deploy it after reviewing the plan.

$ terraform plan -target=module.rds

Enter the user name and password for the DB and store the credentials in a secure place, If you lose the credentials we cannot able to retrieve them back.

Once you reviewed the plan let's deploy

$ terraform apply -target=module.rds

(j) Now, let's create a plan for the CloudWatch stack and deploy it after reviewing the plan.

$ terraform plan -target=module.cloudwatch

Once you reviewed the plan let's deploy

$ terraform apply -target=module.cloudwatch

(k). Now, let's create a plan for the S3 (Simple Storage Service) stack and deploy it after reviewing the plan.

$ terraform plan -target=module.s3

Once you reviewed the plan let's deploy,

$ terraform apply -target=module.s3

(l). Now, let's create a plan for the Cloudfront stack and deploy it after reviewing the plan.

$ terraform plan -target=module.cloudfront

Once you reviewed the plan let's deploy,

$ terraform apply -target=module.cloudfront

(m). Now, let's create a plan for the ECS stack and deploy it after reviewing the plan.

$ terraform plan -target=module.ecs

Once you reviewed the plan let's deploy,

$ terraform apply -target=module.ecs

```

# CI/CD Setup

1. Admin folder contains the CI/CD pipeline setup script

2. We have the terraform script for VPC, EC2 instance, ALB, Security Group under "admin" folder

3. Commands to launch the CI/CD setup

```

(a). Initialise the terraform in your environment [./env/admin]

      $ cd ./env/admin
      $ terraform init

(a). Now, let's create a plan for the vpc stack and deploy it after reviewing the plan.

$ terraform plan -target=module.vpc

Once you reviewed the plan let's deploy,

$ terraform apply -target=module.vpc

(b). Now, let's create a plan for the bastion server and deploy it after reviewing the plan.

$ terraform plan -target=module.bastion_server

Once you reviewed the plan let's deploy,

$ terraform apply -target=module.bastion_server

(c). Now, let's create a plan for the Jenkins server and deploy it after reviewing the plan.

$ terraform plan -target=module.jenkins_server

Once you reviewed the plan let's deploy

$ terraform apply -target=module.jenkins_server

```