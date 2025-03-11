# miniflux-postgres

## secrets

Secret references is named `miniflux-postgres`

### env variables

| Name              | Description                        | Example   | Required |
|-------------------|------------------------------------|-----------|----------|
| POSTGRES_USER     | User to create to access Postgres  | miniflux  | no       |
| POSTGRES_PASSWORD | Password for user to be created    | secret123 | yes      |
| POSTGRES_DB       | Name of the database to be created | miniflux  | no       |

### configmap

| Name              | Description                        | Example   | Required |
|-------------------|------------------------------------|-----------|----------|
| POSTGRES_DB       | Name of the database to be created | miniflux  | no       |
