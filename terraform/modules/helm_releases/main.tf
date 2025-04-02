resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_version
  namespace  = "argocd"
  wait       = true
  atomic     = true
  cleanup_on_fail = true
  create_namespace = true
  
  values = [
    file("${path.module}/values/argocd-value.yaml"),
    yamlencode({
      configs = {
        repositories = {
          github-repo = {
            url = "https://github.com/${var.github_repository}"
            type = "git"
            name = var.github_repository
            username = "git"
            password = var.github_token
            insecure = false
          }
        }
        secret = {
          # Create secrets for repository credentials
          createSecret = true
        }
      }
    })
  ]

}

# Create an ArgoCD Application CR for the App of Apps pattern

resource "kubectl_manifest" "argocd_app" {
    yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: sealed-secrets
  namespace: argocd
spec:
  project: default
  source:
    chart: sealed-secrets
    repoURL: https://github.com/${var.github_repository}
    targetRevision: "HEAD"
    path: "argo-app"
    directory:
      recurse: true
  destination:
    server: "https://kubernetes.default.svc"
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
YAML

depends_on = [ helm_release.argocd ]
}
