# china-learning-terraform

### 目的
勉強用 PJは個人で三ヶ月ごとに作成しているので、毎度環境を構築する手間を省くため、IaC（Terraform）で環境構築できるようになりました。

### リソース一覧
1. testapi (Cloud Build + Cloud Run)　※　Cloud Runでアプリケーション（API）を実行する
2. GKE
3. ArgoCD
4. Application
   
### 準備
1. GCPプロジェクト作成
2. Githubリポジトリ接続
3. SA(terrafrom)を作成し、credentialsをダウンタウンしてsecret.jsonにリネームしてgcp/dev/におく
   1. セキュリティ管理者
   2. 基本/編集者
4. terraform.tfvars PJ 情報入れ替え
  
### build
``` shell
docker-compose run --rm infra
```

### gcloud default project
``` shell
gcloud auth application-default set-quota-project <PROJECT-ID>
gcloud auth login --no-launch-browser
```

### terraform
``` shell
cd gcp/dev
terraform init
terraform plan
terraform apply
```

### gkeに接続
``` shell
gcloud container clusters get-credentials my-k8s-cluster --zone <region>-a --project <project_id>
```

### ArgoCD　install
``` shell
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

### ArgoCD　login
``` shell
url: http://<EXTERNAL-IP>
kubectl get svc argocd-server -n argocd
user: admin
password: <password>
argocd admin initial-password -n argocd
```

### deploy application into ArgoCD　
``` shell
kubectl apply -f argo/manifest/application.yml 
```

### GKE Ingress Configuration
1. Disable internal TLS  
edit the deployment named “argocd-server” and make the following changes
``` yaml
containers:
      - args:
        - /usr/local/bin/argocd-server
        - --insecure
        name: argocd-server
```
注意事項  
【Disable internal TLS】設定せず、バックエンド接続できない問題が起きる。設定方法が変わっている。以下のリンクを参照して設定する。
https://blog.turai.work/entry/20230513/1683917349
   
2. Create service
``` shell
kubectl apply -f argo/ingress/service.yaml
kubectl apply -f argo/ingress/backend-config.yaml
kubectl apply -f argo/ingress/frontend-config.yaml
gcloud compute addresses create argocd-ingress-ip  --global --ip-version IPV4
kubectl apply -f argo/ingress/managed-certificate.yaml
kubectl apply -f argo/ingress/ingress.yaml
```
   



参考  
[NEG(Network Endpoint Group)を使った負荷分散][def5]
[GKE × Terraformで基本的なk8s 環境を構築する][def4]

[def4]: https://medium.com/google-cloud/configuring-argocd-on-gke-with-ingress-and-github-sso-bf7868942403

[def5]:https://christina04.hatenablog.com/entry/network-endpoint-group

### clean up 　
``` shell
terraform destroy 
```

## 参照
[GKE × Terraformで基本的なk8s 環境を構築する][def]

[def]: https://laboratory.kiyono-co.jp/1032/gcp/

[GCPの環境をTerraformで構築する][def2]

[def2]: https://zenn.dev/slowhand/articles/9d8559de23dcd4

[Argo CD - Declarative GitOps CD for Kubernetes][def3]

[def3]:https://argo-cd.readthedocs.io/en/stable/cli_installation/