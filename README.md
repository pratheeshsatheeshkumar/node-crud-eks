Technical Assignment Project Documentation: Multicloud deployment of Node.js Application.

Introduction This project aims to do Continuous Integration of Node.js application and deploy it to an Amazon EKS (Elastic Kubernetes Service) cluster using Argo CD for continuous deployment. The application utilizes Azure MySQL as the backend database for multi-cloud deployment and simplicity of design. It uses a Node.js application that allows the user to enter the details of players and view the list of all players. It uses MySQL as a database. 


Architectural design considerations

1. I considered the deployment of this application in AWS EKS and selected Azure My SQL service as the database service. Although the best practice is to use a service like AWS RDS(Then the database can be accessible with a private domain inside AWS),here consideration was to implement a multi-cloud architecture without a deeper dive into Azure. So, I utilized SSL/TLS encryption for the Azure db connection.
2.  All the major infrastructures are deployed using IaC practices that use Hashicorp Terraform.
3.  GitHub Actions is chosen as the CI tool to checkout the code, build the Docker image using Dockerfile, and update the deployment.yaml manifest.
4.  Docker hub is used as the image repository ArgoCD is utilized as the Continuos Deployment tool and to monitor the cluster's health in EKS.
5.  CI pipelines Unit test stage, Static Code Analysis using Sonar Qube, and Image vulnerability scanning are skipped for simplicity of the assignment. 

Important security considerations.

1. Terraform state file is stored in a remote S3 bucket and provided access via bucket policies. Versioning is enabled.
2. All the credentials in the entire project are stored as secrets in either GitHub Secrets, Kubernetes Secrets or Amazon Secrets Manager.
3. VPC, Public and Private subnets are created from scratch considering the best practices.
4. Security Groups are created with the least access provision. For public subnet only port 443 is allowed. ALB is utilizing the Public Subnet secured by the ACL firewall.
5. NAT Gateway is implemented for the private subnet's external access. The private subnet has no IGW in its route table.
6. Amazon Certificate Manager(ACM) provided Security certificate is utilized for HTTPS access to https://nopdeapp.pratheesh.online for accessing the application.
7. The domain name https://nopdeapp.pratheesh.online is pointing to the ALB via port 443. All HTTP traffic is redirected to port 443 for security.
8. Azure MySql Service is secured with a TLS certificate from Azure and we can restrict it to accept only traffic from the EKS cluster's public ip (I know it is not the best practice). 
9. ArgoCD is authenticated to the manifest file repo using GitHub's Personal Access Token
10. Inside Dockerfile use the VOLUME keyword to create an unnamed volume to separate application and data. We can encrypt it if required.
11. Logging and Monitoring: Cluster logs are published to CloudWatch for logging. Prometheus and Grafana can be used very easily for monitoring. (Not implemented right now.)
