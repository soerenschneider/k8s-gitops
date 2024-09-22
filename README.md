# k8s-gitops

TODO

## Bootstrapping a new cluster

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
