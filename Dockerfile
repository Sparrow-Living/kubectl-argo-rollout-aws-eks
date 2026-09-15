FROM amazon/aws-cli:latest

ARG KUBECTL_RELEASE=v1.31.0
ARG IAM_AUTHENTICATOR_RELEASE=0.6.11
ARG ARGO_ROLLOUTS_RELEASE=v1.10.0

# Direct release downloads only. api.github.com rate-limits unauthenticated
# calls per IP, and shared CI runners regularly hit that limit.
RUN curl -fsSL -o /usr/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_RELEASE}/bin/linux/amd64/kubectl" && \
    curl -fsSL -o /usr/bin/aws-iam-authenticator "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${IAM_AUTHENTICATOR_RELEASE}/aws-iam-authenticator_${IAM_AUTHENTICATOR_RELEASE}_linux_amd64" && \
    curl -fsSL -o /usr/local/bin/kubectl-argo-rollouts "https://github.com/argoproj/argo-rollouts/releases/download/${ARGO_ROLLOUTS_RELEASE}/kubectl-argo-rollouts-linux-amd64" && \
    chmod +x /usr/bin/kubectl /usr/bin/aws-iam-authenticator /usr/local/bin/kubectl-argo-rollouts && \
    kubectl version --client && \
    aws-iam-authenticator version && \
    kubectl argo rollouts version

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
