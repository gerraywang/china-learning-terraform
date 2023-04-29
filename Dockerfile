# https://hub.docker.com/r/hashicorp/terraform
FROM hashicorp/terraform:1.4.5 as terraform

FROM google/cloud-sdk:426.0.0-alpine

COPY --from=terraform /bin/terraform /usr/local/bin/terraform

RUN apk --update add vim
RUN gcloud components install kubectl
RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
RUN install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
RUN rm argocd-linux-amd64
# https://github.com/gruntwork-io/terragrunt/releases
RUN curl -L "https://github.com/gruntwork-io/terragrunt/releases/download/v0.36.7/terragrunt_linux_amd64" -o /usr/local/bin/terragrunt \
    && chmod +x /usr/local/bin/terragrunt