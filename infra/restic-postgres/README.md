# restic-postgres

Perform backups for postgres databases.

## Postgres versions
There are multiple postgres flavors to chose from regarding the postgres major version.
Check out the [available images](https://github.com/soerenschneider?tab=packages&repo_name=scripts).

## secrets
Secret referenced from miniflux is named `miniflux`

### env vars
| Name                  | Description                  | Example   | Required |
|-----------------------|------------------------------|-----------|----------|
| RESTIC_PASSWORD       | Password for the restic repo | secret123 | yes      |
| AWS_ACCESS_KEY_ID     | AWS access key id            | xxx       | no       |
| AWS_SECRET_ACCESS_KEY | AWS secret key               | xxx       | no       |


## configmaps
Optional configmap that is referenced by default is named `restic-postgres`.

| Name              | Description             | Example                                      | Required |
|-------------------|-------------------------|----------------------------------------------|----------|
| RESTIC_REPOSITORY | URL of the restic repo  | s3:s3.amazonaws.com/soerenschneider-backups/ | yes      |
| RESTIC_BACKUP_ID  | Id of the restic backup | my-backup                                    | yes      |
| POSTGRES_HOST     | Host of the postgres db | postgres                                     | yes      |


## external links
- https://restic.readthedocs.io/en/stable/040_backup.html#environment-variables

# Using this resources

## Kustomize component

Use the following `kustomization.yaml` content to include the cronjobs within your namespace.

```yaml
---
apiVersion: kustomize.config.k8s.io/v1alpha1
kind: Component
resources:
  - ../../../../infra/restic-postgres # path to this directory
patches:
  - target:
      kind: "CronJob"
    patch: |
      - op: "replace"
        path: "/spec/jobTemplate/spec/template/spec/containers/0/envFrom"
        value:
          - configMapRef:
              name: "miniflux-restic-postgres"
          - secretRef:
              name: "miniflux-restic-postgres"
      - op: "replace"
        path: "/spec/jobTemplate/spec/template/metadata/labels/restic~1name"
        value: "miniflux"
  - target:
      kind: "CronJob"
      name: "restic-postgres-backup"
    patch: |
      - op: "replace"
        path: "/spec/schedule"
        value: "5 6 * * *" # your desired schedule
      - op: "replace"
        path: "/spec/jobTemplate/spec/template/spec/containers/0/env/0/valueFrom/secretKeyRef/name"
        value: "miniflux-postgres"
      - op: "add"
        path: "/spec/jobTemplate/spec/template/spec/containers/0/envFrom/-"
        value:
          secretRef:
            name: "miniflux-postgres"
  - target:
      kind: "CronJob"
      name: "restic-postgres-prune"
    patch: |-
      - op: "replace"
        path: "/spec/schedule"
        value: "5 22 * * *" # your desired schedule
```

## Triggering a restore
```shell
kubectl create job restore --from=cronjob/restic-postgres-restore
kubectl exec -it restore-xxx -- sh
# do your work here
kubectl delete job restore
```
