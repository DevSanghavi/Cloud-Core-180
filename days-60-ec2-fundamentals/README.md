# Day 60: AWS EC2 Fundamentals Deployment Log

## Practical Deployment Name
* **Lab Name**: Launching Your First Virtual Server via AWS EC2
* **Target Environment**: Amazon Web Services (AWS)
* **Region**: us-east-1 (N. Virginia)

## Technical Methodology
1. **Infrastructure Provisioning**: Deployed an Ubuntu 22.04 LTS operating system template on a `t2.micro` hardware footprint.
2. **Access Controls**: Created a 2048-bit RSA key pair for cryptographic SSH authentication and modified file permissions to `400` to satisfy local safety constraints.
3. **Network Firewalling**: Configured a stateful AWS Security Group opening standard port 22 (SSH) for administration and port 80 (HTTP) for public inbound web traffic.
4. **Application Stack**: Connected via terminal to the remote instance, executed software repository synchronizations, and deployed an Nginx reverse-proxy server.
5. **Content Delivery**: Used root administrative privileges via `tee` to inject custom HTML content into the web layout directory.

## Execution Outcomes
* **Service Availability**: The virtual server successfully verified operational performance checks (`2/2 checks passed`).
* **Web Server Delivery**: The Nginx engine correctly captured HTTP network traffic arriving on port 80 and successfully returned the custom browser heading message over the public internet.
