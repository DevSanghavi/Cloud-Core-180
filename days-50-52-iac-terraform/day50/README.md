# Day 50: Introduction to Infrastructure as Code (IaC) with Local Terraform

## What are we doing today?
Today, we are shifting our focus from writing manual container instructions to managing infrastructure using code. We are installing the Terraform CLI engine on our local system. Instead of talking to a public cloud provider like AWS right away, we are configuring Terraform to talk directly to our local Docker engine. We will use Terraform to pull an Nginx web server image and launch a live container automatically.

## Why are we doing this?
1. **To Learn the Tool First, Not the Platform**: AWS is massive and costs money if misconfigured. By practicing Terraform with Docker locally, we eliminate financial risk and configuration confusion. You can focus 100% of your brain on learning Terraform's syntax, logic, and workflow.
2. **To Eliminate Manual Work**: Modern software companies strictly ban engineers from clicking buttons on websites to build infrastructure. They write code to declare resources. This makes setups fast, repeatable, and completely safe from human mistakes.
3. **To Move Closer to a Cloud Job**: Whether an engineer is building an AWS server, a Kubernetes cluster, or a pipeline, they use Terraform. Mastering these exact core CLI commands (`init`, `plan`, `apply`) locally gives you the precise automation skills companies look for when hiring DevOps/SRE engineers.

## How did we do it?
1. **Installed the Engine**: Added the official HashiCorp software repositories and installed the Terraform CLI utility.
2. **Declared the Desired State**: Created a `main.tf` configuration file using HCL (HashiCorp Configuration Language) to describe our target system (an Nginx container listening on external port 8080).
3. **Initialized the Translator**: Ran `terraform init` to download the specific Docker provider plugin. This acts as a translator so Terraform knows how to talk to our local Docker socket.
4. **Reviewed the Blueprint**: Ran `terraform plan` to double-check exactly what changes Terraform would safely make before touching anything.
5. **Built the Infrastructure**: Executed `terraform apply` to launch the live container and generate our state memory tracking file.
6. **Cleaned Up Completely**: Ran `terraform destroy` to clear the environment back to a blank state.

## Summary of Day 50
Today is a major transition day. We bridged our container orchestration knowledge directly into a production-grade Infrastructure as Code workflow. We learned that Terraform is a declarative tool—meaning we write down the final target state we want, and Terraform does the heavy lifting to make it happen. We successfully proved that we can write, format, validate, execute, and destroy a real system architecture entirely from text configuration files.
