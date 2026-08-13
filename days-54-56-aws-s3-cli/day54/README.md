# AWS CLI Identity and Profile Control (Day 54)

## What We Did Today
Today, we transitioned from managing AWS using a web browser to using the **AWS Command Line Interface (CLI)** inside our Linux/WSL terminal. 

We executed four major milestones:
1.  **System Preparation**: Verified our OS and installed system packages (`wget`, `unzip`).
2.  **AWS CLI v2 Installation**: Downloaded, extracted, and installed the official 64-bit AWS CLI binary directly from Amazon's servers.
3.  **Secure Identity Linking**: Created programmatic programmatic access keys via the AWS IAM Console using a safe, non-root account.
4.  **Profile Architecture Configuration**: Setup a dedicated named profile (`cloudmentor-admin`) to securely route commands and validated it using the AWS Security Token Service (STS).

---

## Why We Did This
*   **Automation Readiness**: Production environments require managing architecture programmatically via code and scripts rather than manually clicking buttons in a browser console.
*   **Accident Prevention**: Real-world cloud engineers frequently jump between development, staging, and production environments. Configuring **Named Profiles** ensures you do not run destructive actions on the wrong AWS account.
*   **Security Best Practices**: By avoiding the AWS Root Account and masking your access keys behind a profile, you minimize the risk of leaked credentials and unauthorized access.

---

## Today's Practical Exercises

### 1. Core Platform Setup
*   **System Audit**: Verify the OS architecture context using `uname -a`.
*   **Binary Deployment**: Pull and unpack the AWS CLI v2 target ZIP payload into the temporary workspace `/tmp/`.
*   **System Path Integration**: Bind the executable engine globally into `/usr/local/bin/aws`.

### 2. Profile Initialization
*   **IAM Key Generation**: Provision programmatic API access keys for your administrative identity via the web UI.
*   **Interactive Configuration**: Bind your secure keys, target deployment region (`ap-south-1`), and standard JSON formatting to the named profile.

### 3. Identity Verification Gates
*   **Live Token Validation**: Trigger `aws sts get-caller-identity` to securely check your active account numbers with AWS servers.
*   **Output Parsing Filters**: Isolate your specific Identity Amazon Resource Name (ARN) using the `--query` filter flags.

### 4. Environment Scope Evaluation
*   **Shell Context Variables**: Use `export AWS_PROFILE` to globally point the shell process to your configured profile.
*   **Environment Reset**: Clean your environment tracking states using `unset` to avoid conflicting credential issues.

---

## Core Definitions for reference

*   **Profile**: A named collection of login parameters used by your local machine to target a specific cloud account.
*   **Credential**: Proof-of-identity data strings used to execute background requests.
*   **STS (Security Token Service)**: The internal AWS authentication guard that verifies token validity.
*   **API (Application Programming Interface)**: The background interface rules that allow your terminal tools to command AWS datacenters.
*   **Credential Chain**: The strict order of locations your terminal looks into when tracking down operational credentials.
