# china-learning-terraform

## run

### SAを作成し、credentialsをダウンタウンしてsecret.jsonの内容を上書く

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