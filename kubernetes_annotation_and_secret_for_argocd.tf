# Apply after argo cluster is created
resource "kubernetes_annotations" "argocd_app_controler_annotation" {
  provider = kubernetes.argocd
  api_version = "v1"
  kind        = "ServiceAccount"
  metadata {
    name = "argocd-application-controller"
    namespace = "argocd" 
  }
  annotations = {
    "iam.gke.io/gcp-service-account" = google_service_account.service_account.email
  } 
   depends_on = [module.argo_cd] 
}

resource "kubernetes_annotations" "argocd_server_annotation" {
  provider = kubernetes.argocd
  api_version = "v1"
  kind        = "ServiceAccount"

  metadata {
    name = "argocd-server"
    namespace = "argocd" 
  }
  annotations = {
    "iam.gke.io/gcp-service-account" = google_service_account.service_account.email
  }
   depends_on = [module.argo_cd] 
}

data "template_file" "docker_config_script" {
  template = "${file("${path.module}/config.json")}"
  vars = {
    docker-username           = "${var.docker_username}"
    docker-password           = "${var.docker_password}"
    docker-server             = "${var.docker_server}"
    docker-email              = "${var.docker_email}"
    auth                      = base64encode("${var.docker_username}:${var.docker_password}")
  }
}

# This will enable application to pull the needed image from the docker registry
# Apply after application cluster is created, and added to argoCD
resource "kubernetes_secret" "docker-registry-dev" {
  provider = kubernetes.application
  metadata {
    name = "regcred"
    namespace = "dev"
  }

  data = {
    ".dockerconfigjson" = "${data.template_file.docker_config_script.rendered}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret" "docker-registry-stage" {
  provider = kubernetes.application
  metadata {
    name = "regcred"
    namespace = "stage"
  }

  data = {
    ".dockerconfigjson" = "${data.template_file.docker_config_script.rendered}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_secret" "docker-registry-prod" {
  provider = kubernetes.application
  metadata {
    name = "regcred"
    namespace = "prod"
  }

  data = {
    ".dockerconfigjson" = "${data.template_file.docker_config_script.rendered}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

