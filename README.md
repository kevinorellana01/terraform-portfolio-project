# Portfolio Website Deployment with AWS and Terraform

This repository contains the deployment files for James Smith's portfolio website, created using the Next.js framework. The deployment leverages AWS services and Infrastructure as Code (IaC) using Terraform for automation and scalability.

For the full documentation of the project: [Medium](https://medium.com/@kevinn.orellana01/building-and-deploying-a-scalable-next-js-portfolio-website-on-aws-with-terraform-e40782397f9b)
## Project Overview

### Client
- **Name**: James Smith
- **Profession**: Freelance Web Designer

### Requirements
The portfolio website must be:
- **Highly Available**: Accessible worldwide with minimal downtime.
- **Scalable**: Handle increased traffic seamlessly.
- **Cost-Effective**: Optimize hosting costs.
- **Fast Loading**: Deliver quick page load times for global users.

### Architecture Overview
![image](https://github.com/user-attachments/assets/42f88eb3-dcf2-4d2d-b603-ed211a687a37)

- **Frontend Framework**: Next.js
- **Hosting**: AWS S3 for static site hosting.
- **Content Delivery**: AWS CloudFront for global distribution and caching.
- **IaC**: Terraform for AWS resource provisioning.

---

## Quick Overview of Next.js

Next.js is an open-source React framework designed for building modern, scalable, and SEO-friendly web applications. Key features include:
- **Server-Side Rendering (SSR)**
- **Static Site Generation (SSG)**
- **File-Based Routing**
- **Built-In API Routes**
- **Automatic Code Splitting**

For more details, visit the [Next.js Documentation](https://nextjs.org/docs).

---

## Steps to Deploy the Portfolio

### 1. Prepare the Next.js Application

#### 1.1 Create a GitHub Repository
1. Go to GitHub and create a repository named `terraform-portfolio-project`.
2. Clone the repository:
    ```bash
    git clone https://github.com/<your-username>/terraform-portfolio-project.git
    cd terraform-portfolio-project
    ```

#### 1.2 Clone the Next.js Portfolio Starter Kit
1. Clone the starter kit:
    ```bash
    npx create-next-app@latest nextjs-blog --use-npm --example "https://github.com/vercel/next-learn/tree/main/basics/learn-starter"
    ```
2. Navigate to the project directory and start the app:
    ```bash
    cd blog
    npm run dev
    ```

#### 1.3 Update Next.js Configuration
1. Create a file named `next.config.js` in the root folder and add the following:
    ```javascript
    const nextConfig = {
      output: 'export',
    };

    module.exports = nextConfig;
    ```
2. Build the static site:
    ```bash
    npm run build
    ```
   This will generate an `out` folder.

#### 1.4 Push Code to GitHub
1. Initialize Git and push the project:
    ```bash
    git init
    git add .
    git commit -m "Initial commit of Next.js portfolio starter kit"
    git remote add origin https://github.com/<your-username>/terraform-portfolio-project.git
    git push -u origin master
    ```
---

### 2. Set Up Terraform Configuration

#### 2.1 Create Terraform Directory
```bash
mkdir terraform-nextjs
cd terraform-nextjs
```

#### 2.2 Create Terraform Files
1. **State Management**: Configure S3 and DynamoDB for storing the Terraform state.
2. **Provider Block**: Add AWS provider configurations in `main.tf`.
3. **S3 Bucket**: Create an S3 bucket for static website hosting with properties like `index_document` and `error_document`.
4. **Bucket Policy**: Add an S3 bucket policy to allow public read access.
5. **CloudFront Distribution**: Configure CloudFront with the following:
    - Origin pointing to the S3 bucket.
    - Viewer protocol policy: `redirect-to-https`.
    - Default cache behavior for `GET` and `HEAD` requests.
6. **Outputs**: Define outputs for the S3 bucket name and CloudFront domain.

#### 2.3 Initialize Terraform
```bash
terraform init
```

#### 2.4 Plan and Apply Terraform
1. Preview the changes:
    ```bash
    terraform plan
    ```
2. Apply the changes:
    ```bash
    terraform apply
    ```

---

### 3. Deploy the Next.js Static Site
1. Upload the `out` folder to the S3 bucket:
    ```bash
    aws s3 sync ../blog/out s3://<your-s3-bucket-name>
    ```
2. Retrieve the CloudFront URL:
    ```bash
    terraform output cloudfront_url
    ```
3. Access the website using the CloudFront URL.

---

## Key Features
- **Infrastructure as Code**: Automated AWS resource creation with Terraform.
- **Global Content Delivery**: Optimized performance with CloudFront.
- **Scalability**: Seamless handling of traffic spikes.
- **Cost Optimization**: Static hosting with S3 and on-demand scaling.

---



