# Infrastructure Cost Analysis

## Estimated Monthly Infrastructure Cost

| Resource | Quantity | Estimated Monthly Cost (USD) |
|----------|---------:|-----------------------------:|
| EC2 Control Plane | 1 | $15.00 |
| EC2 Worker Nodes | 2 | $30.00 |
| EBS Volumes | 3 | $3.00 |
| Route53 Hosted Zone | 1 | $0.50 |
| Domain Name | 1 | $1.00 |
| **Estimated Total** | | **≈ $49.50/month** |

---

## Infrastructure Used

The TaskApp Kubernetes platform consists of:

- 1 Kubernetes Control Plane node
- 2 Kubernetes Worker nodes
- Persistent storage using AWS EBS volumes
- Route53 for DNS management
- Let's Encrypt certificates managed by cert-manager
- Argo CD for GitOps deployments

The infrastructure was provisioned using Terraform and configured using Ansible.

---

## Cost Optimisation

For development and testing, the monthly cost can be reduced by:

- Stopping EC2 instances when they are not in use.
- Using smaller EC2 instance types such as t3.micro where appropriate.
- Running a single worker node for development instead of two.
- Deleting unused EBS volumes after testing.
- Destroying the Terraform infrastructure after completing demonstrations.

These optimizations can reduce the monthly cost by more than 50%.

---

## Conclusion

The estimated monthly cost of running the production-style Kubernetes cluster is approximately **$50 USD per month**.

For development purposes, costs can be significantly reduced by scaling down the infrastructure or destroying it after use using Terraform.