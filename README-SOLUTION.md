# FastAPI Challenge - Solution

## What I Built

Started with a basic FastAPI app and needed to get it running in Kubernetes with Terraform. The Python code was already there, so I built everything else around it.

## The Process

### Getting it Running Locally

First thing I hit was the requirements.txt file. PyTorch was causing build issues on my M1 Mac - something about CPU versions not being available. Spent some time trying to figure out the right Python version (3.9-3.11 range seemed to work), but honestly it was easier to just throw it in a container and move on.

### Docker Setup

Used the basic Dockerfile pattern from Docker docs. Had to add gcc because psutil was failing to build. Also threw in the FastAPI CLI install since that seemed to be the recommended way to run it now.

The environment variables are defined in the Dockerfile for documentation purposes, and are then overwritten in the Helm chart so that part is pretty clean.

### Kubernetes Stuff

Built a Helm chart following the standard template structure (`helm create`). Nothing too much here - deployment, service, ingress, the usual suspects. Added ServiceMonitor as an extra to fulfill the monitoring requirement.

Had to fix the port mismatch between the Docker container (8080) and what the Helm chart was expecting (80)

### Terraform

Kept this simple. Generated mostly with Claude, but in traditional AI fashion, it went haywire and did too much, simplified it down to just a couple of vars and the rest is Originally started going down a rabbit hole with tons of variables and templating, but that was getting messy. Ended up with just a basic setup that takes a values file and deploys the chart. Much cleaner.

### Pipelines

Added these workflows:
- Quality checks (formatting, linting, security scans)
- Helm validation  
- Deployment pipeline
- Image publishing

The deployment one does dev first, then has a manual gate for prod. Creates the database secret at runtime instead of storing it anywhere.

## How to Use It

### Local Development
```bash
# Build the image
task build-latest

# Deploy to dev
cd infra/terraform
task dev
task port-forward ENV=dev
```

### Production
Push to main branch. Pipeline will deploy to dev automatically, then wait for manual approval for prod.

Need to set these GitHub secrets first:
- `KUBE_CONFIG` - your kubeconfig file (base64 encoded)
- `PROD_DB_PASSWORD` - whatever password you want for prod

## Issues and Compromises

### Things That Could Be Better

The secret management is pretty basic. In a real environment I'd probably use something like External Secrets Operator or Vault.

No real database - just environment variables. The `/data` endpoint shows what's configured but there's no actual persistence.

Health checks are minimal. Real apps need way more :P 

There's no actual deployment happening of course, except for the Helm pipeline testing which is building a kind cluster.

Terraform pipeline and cluster deployment is still mock code as I didn't really get much time to finish that off.

### What I'd Do Differently in Production

- Proper observability stack (logging, metrics, tracing)
- Network policies
- A REAL Terraform state.
- Templating the helm chart first and then deploying it with terraform, because wrapping two stateful deployment tools can lead to bad things (don't ask me how I know)
- Actual database, migrations for extra class :D 
- More comprehensive testing (with ones that actually pass haha)
- Better secret rotation
- Proper dependency management for the python app using something like Poetry, which was outside the scope of this assignment.
- API Validation pipeline requires a little bit more work to be fully functional. The basics are there.
- Chaining together the pipelines, more complex triggers.

## Other Notes

Used Claude to help debug some of the dependency issues and get the pipeline structure right. Saved a bunch of time on the GitHub Actions syntax and generating the boilerplates for most of the tooling. That's how I also did it in the other project. I like to use LLMs to generate boilerplates and then edit them and verify things. It's a more unified way of searching for things I believe.

I prefer Taskfiles over makefiles, it's just how I wrap things usually.

Overall it's a pretty standard containerized app deployment. Nothing groundbreaking, but it works and follows most of the best practices. Could definitely be extended based on actual requirements, and more time, planning etc.