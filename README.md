# Infrastructure-as-Code (IaC) for Governed MLOps
This repository contains the declarative infrastructure definitions for the **Management Control Plane** and **Target Execution Domains** as described in the research paper:

> **"A GitOps-Driven MLOps Framework: Formalizing Reproducibility and State Transitions in the Machine Learning Lifecycle"**

## Related Repositories
To recreate the full experimental environment, this repository must be used in conjunction with:

[MLOPS-deployment](https://github.com/ProductDock/MLOPS-deployment) Contains the Kubernetes manifests and environment-specific overlays.

[telemanom-MLOPS](https://github.com/ProductDock/telemanom-MLOPS) The refactored model logic and DVC-tracked data pipelines.

## Prerequisites
    - Google Cloud SDK (gcloud)

    - Terraform >= 1.5.0

    - Kubernetes CLI (kubectl)

    - ArgoCD CLI

## Deployment Workflow
The infrastructure is provisioned in a tiered approach to ensure network security and cluster synchronization.

### Phase 1: Base Fabric Provisioning
Initialize the core network, VPC, private GKE clusters, service account,workload identitiy resources and storage bucket. 

1.  Configure `terraform.tfvars` with project-specific IDs, docker credentaials, github specifics,  and authorized network ranges.

2. `terraform init` && `terraform apply` of the network, argo and application cluster, service account, workload identitiy resources and service bucket

3. Security Note: Retrieve the NAT IP from the output and add it to `authorized_networks` list   to permit the Management Cluster to communicate with the Workload Cluster.

### Phase 2: Management Plane Bootstrapping
Install the GitOps Controller (ArgoCD) into the Management Cluster.

1. Enable the Helm/Kubernetes providers in `providers.tf`.

2. `terraform apply` to instantiate the ArgoCD service and internal RBAC.

### Phase 3: Cluster Federation and Repository Binding
Register the Workload Cluster and Deployment Repository within the Management Plane.

1. ### Authenticate to the Management Cluster:
    ```bash 
        gcloud container clusters get-credential [MANAGEMENT_CLUSTER_NAME]

2. ### Retrieve ArgoCD Admin Credentials:
    ```bash 
        kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

3. ### Establish Port Forwarding: 
    ```bash 
        kubectl port-forward service/argocd-server -n argocd 6321:80

4. ### Login to ArgoCD (via CLI):
    ```bash 
        argocd login localhost:6321

5. ### Authenticate to the application Cluster:
    ```bash 
        gcloud container clusters get-credentials [APPLICATION_CLUSTER]

6. ### Cluster Registration: 
    Register application cluster to ArgoCD to enable remote reconciliation

    ```bash
        argocd cluster add $(kubectl config current-context) --name application_context

7. ### Source of Truth Binding: 
    Securely connect the private Deployment Repository using a Personal Access Token (PAT):
    ```bash 
        argocd repo add ${GIT_REPO_URL} --username ${USER} --password ${PAT}
8. ### Final Synchronization:
    Update your Terraform variables with the newly generated `argo_destination_server_url` and run a final apply to finalize the Kubernetes annotations:
    ```bash 
        terraform init
        terraform apply
