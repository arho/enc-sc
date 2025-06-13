output "release_name" {
  value = helm_release.fastapi_challenge.name
}

output "namespace" {
  value = helm_release.fastapi_challenge.namespace
}

output "port_forward_command" {
  value = "kubectl port-forward -n ${helm_release.fastapi_challenge.namespace} svc/${helm_release.fastapi_challenge.name}-fastapi-challenge 8080:8080"
}