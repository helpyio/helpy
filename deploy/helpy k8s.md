## Helpy on Kubernetes (K8s)

This document describes how to configure and run Helpy on Kubernetes. Kubernetes is a container
orchistration tool that completely abstracts working with SSH or capistrano and makes
it trivial to run a cluster of Helpy instances.  The configuration described here follows the best pratices
in the wiki for running a High Availability (HA) cluster of Helpy instances.

This version of Helpy uses some different tooling than you would get if you just ran 'rails server' in
development mode or use the standard Docker container.  Istead, there is a new special
Dockerfile which adds the following changes and dependencies:

- Uses the Puma webserver.  This adds some configuration options.
- Uses Nginx to proxy to puma in each container
- Uses a Redis backed cache.  This is configured to be in-memory only, but is shared between all
instances
- Uses the DelayedJob worker instead of suckerpunch, which is in memory only and cannot share jobs
between instances or persist in the event of a reboot.

#### Requirements

This implementation expects a couple things- that you will use a DBaaS such as Amazon AWS RDS or similar services to run a Postgres database.  You should also set up S3 or a compatible file store to save your users file attachments.

### 1. Connect to the K8s server

`export KUBECONFIG=~/.kube/YOUR_K8S_CONNECTION_YAML`

### 2. Copy env.yml.sample to env.yml

First make a production copy of the env.yml file and add your configuration values here. Notably, you will need a database and file storage server like S3 or DigitalOcean spaces.

### 3. Run the deploy

Run the deploy with the following command.

`kubectl apply -f deploy`

This will create the following pods:

- Helpy: a Helpy pod that includes the Helpy container running puma, and nginx sidecar which proxies 
to the puma server
- Background: a Helpy pod that runs the delayed_job runner.
- Redis: a Redis pod that powers the caching for your cluster.

### 3. Run the initial migration to set up your database

Use `kubectl get pods` to get the name of one of your helpy pods.  Next, use the following command
to run the initial migration and seed:

`kubectl exec [your pod] bundle exec rake db:migrate`
`kubectl exec [your pod] bundle exec rake db:seed`

