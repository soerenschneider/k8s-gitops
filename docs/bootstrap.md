# Bootstrap a new Cluster

## 1. Generate AWS hosted zone and IAM credentials

Either create a new environment or re-use an existing environment in the [terragrunt folder](../contrib/terraform) and roll out the changes.

- note down hosted-zone id for later use in cert-manager issuer
- iam credentials will be written to vault

## 2. Connect K8s to Vault

Apply the resources to the cluster
- [vault-auth](../infra/vault-auth)
- [external-secrets](../infra/external-secrets)

External-secrets must be configured with an appropriate (Cluster)SecretStore, such as [Vault ClusterSecretStore](../clusters/dqs.dd.soeren.cloud/infra/external-secrets/vault.yaml).

Gather the following information from the cluster 
- vault-auth service account's JWT. Extract using [vault-kubernetes-get-jwt.sh](../contrib/vault-kubernetes-get-jwt.sh) script.
- UIDs of service accounts for vault-auth and external-secrets. Extract using [vault-get-service-account-uid.sh](../contrib/vault-get-service-account-uid.sh) script.
- TLS cert of Kubernetes cluster. Extract using [kubernetes-get-ca.sh](../contrib/kubernetes-get-ca.sh) script.

Apply values in [tf-vault](https://github.com/soerenschneider/tf-vault/blob/main/envs/prod/tg_variables-secrets.sops.yaml) and roll out changes using terragrunt.
Now, K8s is connected to Vault using [Kubernetes Auth method](https://developer.hashicorp.com/vault/docs/auth/kubernetes).

## 3. Bootstrapping cert-manager

Now cert-manager can be bootstrapped using the AWS credentials written to Vault by using external-secrets.

Check out [this configuration](../clusters/dqs.dd.soeren.cloud/infra/cert-manager) for inspiration.

## 4. Bootstrapping istio

Bootstrap istio using [install.sh](../contrib/istio/install.sh) which installs istio using Istio Operator and the appropriate config file.

Check out [this configuration](../clusters/dqs.dd.soeren.cloud/infra/istio) (Gateways, certificates) is found in each cluster.

