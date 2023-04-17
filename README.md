# china-learning-terraform

## run

### build
``` shell
docker-compose run --rm infra
```

### gcloud default project
``` shell
gcloud auth application-default set-quota-project <PROJECT-ID>
```

### terraform
``` shell
cd gcp/dev
terraform init
terraform plan
```