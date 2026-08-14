# Day 58 — S3 Encryption Enforcement with Bucket Policy Conditions

## 📌 Project Overview
- **Timeline:** Day 58 of 180 Days Cloud Core Engine Mastery Roadmap
- **Practical Name:** Automated Server-Side Encryption Guardrail Deployment
- **Target Provider & Region:** AWS (`us-east-1`)
- **Execution Interface:** POSIX Local Linux Terminal / AWS CLI (`s3api` engine)
- **Deployment Strategy:** 100% Declarative Infrastructure Guardrails (No AWS Console Clicks)

---

## 🔍 What We Did
Today, we initialized an isolated workspace inside our main repo and programmatically deployed an advanced, multi-statement S3 Bucket Policy designed to control and secure ingestion lifecycles. 

Specifically, we:
1. **Provisioned Cloud Infrastructure:** Initialized a dynamic, timestamp-suffixed, non-public S3 bucket box via the terminal.
2. **Engineered an Automated Guardrail Matrix:** Generated a declarative JSON security schema containing complex `StringNotEquals` and `Null` cryptographic condition strings.
3. **Applied Active Boundary Rules:** Applied the policy to intercept incoming API requests targeting the `/secure/*` prefix folder.
4. **Executed Active Verification Proofs:** Proved the policy works by executing a split-test execution matrix:
   - Attempted an unencrypted upload, which was caught and terminated with an `AccessDenied` error.
   - Attempted an `AES256` encrypted upload, which passed the boundary gate smoothly.
5. **Captured Compliance Auditing Records:** Generated local log evidence summaries.
6. **Executed Workspace Clean Deconstruction:** Safely purged all active cloud resources to maintain a zero-cost workspace footprint.

---

## 💡 Why We Did It (The Production Logic)
In modern cloud architecture, human error is one of the highest security risks. An engineer or a misconfigured third-party application might forget to pass encryption headers, leaving data exposed on remote storage blocks. 

Relying on teams to "remember to add encryption later" creates compliance and data-protection failures. We implemented an automatic **Guardrail** to solve this:
- **The Power of Explicit Deny:** Because an explicit `Deny` statement overrides any identity-level permissions, this policy successfully blocks even **Administrator Users** if their upload requests are unsafe.
- **Header Interception:** By inspecting the incoming `s3:x-amz-server-side-encryption` request header at runtime, the bucket acts as its own gatekeeper.
- **Fail-Safe Design (Null Check):** The inclusion of the `Null` validation rule ensures that if an application attempts to completely omit the encryption header parameters, the request is instantly rejected rather than slipping through undetected.

---

## 🛠️ Implemented Policy Architecture Reference

The target `bucket-policy.json` script was engineered using five distinct functional statement blocks:

| Statement ID (Sid) | Enforcement Type | Core Action | Targeted Scope | Operational Mechanics |
| :--- | :--- | :--- | :--- | :--- |
| `DenyInsecureTransport` | **Explicit Deny** | `s3:*` | Global Bucket & Objects | Rejects any request arriving over unencrypted plain text `HTTP` connections (`aws:SecureTransport = false`). |
| `DenyUnencryptedObjectUploads` | **Explicit Deny** | `s3:PutObject` | `secure/*` prefix paths | Rejects ingestion if the encryption algorithm header string is explicitly passed but does not equal `AES256`. |
| `DenyMissingEncryptionHeader` | **Explicit Deny** | `s3:PutObject` | `secure/*` prefix paths | Evaluates a `Null` check condition to catch and block requests that completely lack an encryption header. |
| `AllowUserListSecurePrefix` | **Scoped Allow** | `s3:ListBucket` | Root Bucket Resource | Permits your designated IAM user ARN context to query bucket metadata *only* when scoped to the `secure/` path string. |
| `AllowUserReadSecureObjects` | **Scoped Allow** | `s3:GetObject` | `secure/*` data files | Grants targeted downstream file data read capabilities specifically for encrypted objects under the secure path. |

---

## ⚙️ Active Verification Benchmarks

### 1. The Blocked Test (Unencrypted)
- **Action:** Executed `aws s3api put-object` omitting key encryption parameters.
- **Expected Outcome:** Policy intercept triggers standard AWS access termination.
- **Terminal Proof:**
  ```text
  An error occurred (AccessDenied) when calling the GetObject/PutObject operation: Access Denied
  ```

### 2. The Accepted Test (Encrypted)
- **Action:** Executed `aws s3api put-object` appending the `--server-side-encryption AES256` parameter string.
- **Expected Outcome:** Ingestion succeeds, returning target metadata payloads.
- **Terminal Proof:**
  ```json
  {
      "ServerSideEncryption": "AES256"
  }
  ```

---

## 🗃️ Main Repo Workspace Tracking
- **Local Directory:** `~/cloud-practice/Cloud-Core-180/day-58-s3-encryption-policy/`
- **Committed Artifacts:**
  - `bucket-policy.json` (The engineered 5-statement schema)
  - `command-log.txt` (Local execution trace logs)
  - `bucket-name.txt` / `user-arn.txt` (Workspace isolation parameters)
