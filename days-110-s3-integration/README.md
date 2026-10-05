# Day 110 — S3 Integration Patterns
## What We Are Studying
S3 static website hosting serves HTML/CSS/JS directly from buckets. Pre-signed URLs grant temporary access to private objects without making them public.
## Commands Used
| Command | Purpose |
|---------|---------|
| `aws s3api create-bucket` | Create S3 bucket |
| `aws s3 website` | Enable static hosting |
| `aws s3 presign s3://bucket/key` | Generate pre-signed URL |
| `aws s3 cp` | Upload files to S3 |
