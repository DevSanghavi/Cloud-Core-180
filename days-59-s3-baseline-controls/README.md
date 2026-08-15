# Day 59: S3 Baseline Controls

## Topic Overview
This day covers S3 Default Encryption and Object Ownership (`BucketOwnerEnforced`). We are standardizing bucket security by automatically encrypting all incoming files and completely disabling legacy Access Control Lists (ACLs).

## Execution Process
1. Create a dedicated workspace and an isolated S3 bucket.
2. Apply a default encryption policy using AES256 configuration files.
3. Apply bucket owner ownership controls to disable object-level ACLs.
4. Validate bucket states using get-bucket-encryption and get-bucket-ownership-controls.
5. Perform a baseline upload without encryption flags to verify automatic server-side encryption.
6. Test and record the expected failure when trying to use an ACL flag on an object.
7. Document metadata proofs, clean up cloud resources, and commit workspace progress to Git.
