# Runbook

This runbook explains how to provision, deploy, operate and recover the TaskApp Kubernetes platform.

---

# Provision from zero

## 1. Provision infrastructure

```bash
cd infra/terraform

terraform init

terraform plan

terraform apply
```

Terraform provisions:

- 1 Kubernetes Control Plane
- 2 Kubernetes Worker Nodes
- Networking
- Security Groups

---

## 2. Configure Kubernetes

```bash
cd ../ansible

ansible-playbook playbook.yml
```

Verify:

```bash
kubectl get nodes
```

Expected:

```
3 Ready nodes
```

---

## 3. Verify kubeconfig

```bash
kubectl get nodes -o wide
```

---

## 4. Platform components

Verify:

```bash
kubectl get pods -A
```

Platform components should include:

- ingress-nginx
- cert-manager
- metrics-server
- Argo CD

---

## 5. GitOps

Application deployment is managed by Argo CD.

Verify:

```bash
kubectl get application taskapp -n argocd
```

Expected:

```
SYNC STATUS: Synced

HEALTH STATUS: Healthy
```

---

# Day-2 Operations

## Scale a tier

Manual:

```bash
kubectl scale deployment backend --replicas=3 -n taskapp
```

Preferred production method:

Update the Kubernetes manifest in GitHub.

Argo CD automatically synchronizes the cluster.

---

## Roll back a bad deployment

```bash
kubectl rollout undo deployment/backend -n taskapp
```

---

## Run a new migration safely

Database schema changes are executed using the Kubernetes Migration Job.

The backend containers do not execute migrations automatically, preventing migration race conditions when multiple replicas exist.

---

## Rotate a Secret

Update the Secret manifest in Git.

Commit the changes.

Push to GitHub.

Argo CD synchronizes the updated Secret automatically.

---

# Failure Recovery

## Worker node fails or is drained

Drain the worker:

```bash
kubectl drain <worker-node> --ignore-daemonsets --delete-emptydir-data
```

Expected behaviour:

- Kubernetes reschedules frontend and backend Pods to healthy worker nodes.
- Application remains available.
- Argo CD continues managing desired state.

Restore scheduling:

```bash
kubectl uncordon <worker-node>
```

Expected recovery:

Approximately one to two minutes.

---

## Backend Pod CrashLoopBackOff

Diagnose:

```bash
kubectl describe pod <pod-name> -n taskapp

kubectl logs <pod-name> -n taskapp

kubectl logs --previous <pod-name> -n taskapp
```

If necessary:

```bash
kubectl rollout restart deployment/backend -n taskapp
```

---

## Bad Migration

Migration runs as a dedicated Kubernetes Job.

If the migration fails:

- Correct the migration
- Commit changes
- Push to GitHub
- Argo CD redeploys the updated Job

---

## PostgreSQL Recovery

Delete PostgreSQL Pod:

```bash
kubectl delete pod postgres-0 -n taskapp
```

Expected:

- StatefulSet recreates the Pod.
- Persistent Volume Claim reattaches automatically.
- Database remains intact.