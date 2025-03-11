# miniflux

## secrets
Secret referenced from miniflux is named `miniflux`

### env vars
| Name           | Description              | Example                                                | Required |
|----------------|--------------------------|--------------------------------------------------------|----------|
| DATABASE_URL   | Postgres DSN             | postgres://miniflux:secret@db/miniflux?sslmode=disable | yes      |
| ADMIN_USERNAME | Admin username to create | miniflux                                               | no       |
| ADMIN_PASSWORD | Admin password           | secret123                                              | no       |


## configmaps
Configmap that is referenced by default is named `miniflux` and is created by kustomize configMapGenerator.

| Name           | Description       | Example | Required |
|----------------|-------------------|---------|----------|
| RUN_MIGRATIONS | Run db migrations | 1       | no       |
| CREATE_ADMIN   | Create admin user | 1       | no       |


## external links
- https://miniflux.app/docs/docker.html
