# china-learning-terraform

### 目的
勉強用PJは個人で三ヶ月ごとに作成しているので、毎度環境を構築する手間を省くため、IaC（Terraform）で環境構築できるようになりました。

### リソース一覧
1. testapi (Cloud Build + Cloud Run)　※　Cloud Runでアプリケーション（API）を実行する
2. GKE
   
### 準備
1. GCPプロジェクト作成
2. Githubリポジトリ接続
3. SAを作成し、credentialsをダウンタウンしてsecret.jsonの内容を上書く
   1. セキュリティ管理者
   2. 編集者
4. terraform.tfvars PJ情報入れ替え
  
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

## 参照
[GKE × Terraformで基本的なk8s環境を構築する][def]

[def]: https://laboratory.kiyono-co.jp/1032/gcp/

[GCPの環境をTerraformで構築する][def2]

[def2]: https://zenn.dev/slowhand/articles/9d8559de23dcd4