resource "helm_release" "argocd" {
  name = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = var.argocd_chart_name
  namespace        = var.argocd_k8s_namespace
  version          = var.argocd_chart_version
  create_namespace = true

  values = [
    templatefile("./modules/argocd/application.yaml", {
      app_deployment_repo = "https://github.com/${var.github_deployment_repo}"
      server_url         = "${var.server_url}"
    })
  ]
}
