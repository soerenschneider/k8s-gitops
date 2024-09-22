# k8s-gitops

![security](https://github.com/soerenschneider/k8s-gitops/actions/workflows/security-scanners.yaml/badge.svg)
![lint](https://github.com/soerenschneider/k8s-gitops/actions/workflows/lint.yaml/badge.svg)


## Key Technologies

- **Kubernetes**: Orchestrates the deployment, scaling, and operations of containerized applications.
- **Flux CD**: GitOps continuous delivery solution for Kubernetes.
- **Istio**: A service mesh that provides advanced networking capabilities such as traffic management, security, and observability.
- **Cert-Manager**: Manages the issuance and renewal of TLS certificates.
- **External Secrets**: Integrates external secret stores (AWS Secrets Manager, HashiCorp Vault, etc.) with Kubernetes.
- **External DNS**: Dynamically updates DNS records based on Kubernetes resources.
- **Renovatebot**: Keeps track of updated versions for the manifests.

## Repository Structure

This repository is structured to follow GitOps principles, with Kubernetes manifests for different environments (e.g., development, staging, production) stored here and managed via Flux CD.

```bash
├── apps/
│   ├── app1/
│   ├── app2/
│   └── app3/
├── clusters/
│   ├── cluster-1/
│   ├── cluster-2/
│   ├── cluster-.../
│   ├── cluster-n/
├── contrib/
│   ├── flux/
│   ├── istio/
│   ├── terraform/
├── infra/
│   ├── app1/
│   ├── app2/
```

### Folder Overview:

- **apps/**: Application manifests for various services.
- **clusters/**: Environment-specific configurations for different Kubernetes clusters.
- **contrib/**: Tools to help boostrapping clusters.
- **infra/**: Low-level platform apps and configurations.

## Bootstrapping a New Cluster

### Flux
Navigate to `contrib/flux/$CLUSTER_NAME` and run

```shell
bash ../flux2/new-deploy-key.sh
kubectl apply -k .
```

### Route53 hosted zone
Navigate to `contrib/terraform/envs/$CLUSTER_NAME`.
Terraform creates a new (sub) hosted zone, IAM credentials and policies for cert-manager and external-dns.

### Istio
```shell
sh contrib/istio/install.sh $CLUSTER_NAME
```

### Vault authentication integration
```shell
kubectl apply -k clusters/$CLUSTER_NAME/infra/vault-auth
```

Retrieve token reviewer JWT value. Handle this value with care!
```shell
kubectl get secrets -n vault-auth vault-kubernetes-auth-secret -o=jsonpath='{.data.token}' | base64 -d
```

```shell
kubectl get secrets -n vault-auth vault-kubernetes-auth-secret -o=jsonpath="{.data['ca\.crt']}" | base64 -d
```
