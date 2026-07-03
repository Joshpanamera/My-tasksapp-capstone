# TaskApp Kubernetes Architecture

## 1. Topology Diagram

```text
                         Internet
                             │
                             ▼
                taskapp.yourdomain.com
                             │
                             ▼
                    NGINX Ingress Controller
                  (TLS via cert-manager)
                             │
        ┌────────────────────┴────────────────────┐
        ▼                                         ▼
Frontend Service                           Backend Service
        │                                         │
        ▼                                         ▼
Frontend Pods (2 replicas)              Backend Pods (2 replicas)
        │                                         │
        └────────────── /api ─────────────────────┘
                                                  │
                                                  ▼
                                      PostgreSQL StatefulSet
                                             (PVC)
```

Cluster Nodes

- Control Plane: ip-10-0-1-34
- Worker 1: ip-10-0-1-149
- Worker 2: ip-10-0-1-238

Pods are automatically scheduled across worker nodes for high availability.

---

# 2. Node & Network

## Nodes

- 1 Control Plane
- 2 Worker Nodes

Operating System

- Ubuntu 24.04 LTS

Kubernetes

- k3s v1.36

Infrastructure

Provisioned using Terraform.

Cluster configuration performed using Ansible.

## Networking

Private subnet:

10.0.1.0/24

Security Groups

Public access:

- SSH (22) restricted to my IP
- HTTP (80)
- HTTPS (443)

Internal only:

- Kubernetes API (6443)
- Node-to-node communication

The Kubernetes API is intentionally not exposed publicly to improve cluster security.

---

# 3. Request Flow

A user accesses TaskApp through the public domain.

DNS resolves the domain to the public IP of the Kubernetes cluster.

The request reaches the NGINX Ingress Controller where HTTPS is terminated using certificates issued automatically by cert-manager and Let's Encrypt.

Traffic is routed to the Frontend Service.

The React frontend serves the user interface.

API requests are forwarded to the Backend Service.

The Flask backend processes the request and communicates with PostgreSQL through an internal ClusterIP service.

Responses are returned through the Ingress Controller back to the client.

---

# 4. Single-server Assumptions Fixed

| Single-server assumption | Why it breaks | Solution |
|--------------------------|--------------|----------|
| Database migration runs inside backend container | Multiple replicas may execute migrations simultaneously | Dedicated Kubernetes Job performs migrations once |
| Local Docker volume | Pods may move between worker nodes | PostgreSQL deployed as StatefulSet with Persistent Volume Claim |
| Host port publishing | Multiple Pods cannot all bind the same port | Kubernetes Services and NGINX Ingress provide a single entry point |
| One backend instance | Failure causes downtime | Deployment with two backend replicas |
| One frontend instance | Failure causes downtime | Deployment with two frontend replicas |
| Manual deployment | Error-prone and inconsistent | Argo CD GitOps continuously synchronizes GitHub to the cluster |
| Plain HTTP | Traffic is unencrypted | HTTPS using cert-manager and Let's Encrypt |
| Configuration stored inside images | Difficult to manage | ConfigMaps and Kubernetes Secrets |

---

# 5. Design Choices & Trade-offs

## Raw YAML

Raw Kubernetes manifests were chosen instead of Helm because this project focuses on demonstrating a detailed understanding of Kubernetes resources.

## NGINX Ingress

NGINX Ingress Controller was selected because it integrates well with cert-manager, supports advanced routing, and is widely used in production Kubernetes environments.

## GitOps

Argo CD continuously watches the GitHub repository and automatically synchronizes Kubernetes manifests to the cluster, making Git the single source of truth.

## High Availability

Two replicas are used for both frontend and backend deployments.

Pods are spread across multiple worker nodes to improve resilience during node failures.

## Storage

PostgreSQL runs as a StatefulSet with a Persistent Volume Claim to ensure database persistence even if the Pod is recreated.

## Security

Application configuration is separated into ConfigMaps and Secrets.

Container images use pinned versions instead of the latest tag.

HTTPS is enforced using Let's Encrypt certificates managed automatically by cert-manager.