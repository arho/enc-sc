variable "kubeconfig_path" {
  description = "Path to kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "fastapi-challenge"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "fastapi-challenge"
}

variable "chart_path" {
  description = "Path to Helm chart"
  type        = string
  default     = "../k8s/fastapi-challenge"
}

variable "values_file" {
  description = "Path to values file"
  type        = string
  default     = "values.yaml"
}