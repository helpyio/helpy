#!/bin/sh -ex
#export KUBECONFIG=~/.kube/kubernetes-rails-example-kubeconfig.yaml

# Have to build assets here instead of in the container
bundle exec rake assets:precompile
docker build -t helpy/helpy:kubernetes -f Dockerfile.kube .
docker push helpy/helpy:kubernetes
# kubectl create -f config/kube/migrate.yml
# kubectl wait --for=condition=complete --timeout=600s job/migrate
# kubectl delete job migrate
kubectl rollout restart deployment/helpy
kubectl rollout restart deployment/background
kubectl rollout restart deployment/redis