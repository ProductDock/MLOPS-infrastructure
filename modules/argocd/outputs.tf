output "argo_cluster_namespace" {
  value = helm_release.argocd.namespace
}