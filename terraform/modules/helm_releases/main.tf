resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_version
  namespace  = "argocd"
  wait       = true
  atomic     = true
  cleanup_on_fail = true
  values     = ["values/argocd-value.yaml"]
}


