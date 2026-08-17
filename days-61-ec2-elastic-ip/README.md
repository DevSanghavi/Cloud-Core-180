# Day 61: AWS EC2 Lifecycle Operations & Elastic IPs

## Practical Deployment Name
* **Lab Name**: Managing EC2 Lifecycles, Static Elastic IPs, and Console Connections
* **Target Environment**: Amazon Web Services (AWS)
* **Region**: us-east-1 (N. Virginia)

## Technical Methodology
1. **Lifecycle Operations**: Polled existing instance states using CLI filters, then executed a controlled boot sequence on the `day60-webserver` asset.
2. **Static Network Provisioning**: Allocated a static public IPv4 network token (Elastic IP) within the regional VPC ecosystem.
3. **Network Association Binding**: Bound the static token to the active virtual server instance, instantly overriding the dynamic pool address.
4. **Alternative Authentication**: Tested browser-based IAM connections via EC2 Instance Connect to audit active Nginx system states without standard key pairs.

## Execution Outcomes
* **Network Stability**: Stopping and starting the instance no longer alters our public routing address. The application remains statically bound to the Elastic IP.
* **Emergency Access Path Verified**: Browser-based terminal operations successfully bypass local machine access blockers, ensuring support visibility if keys are compromised.
