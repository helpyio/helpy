## Helpy on Kubernetes (K8s)

This document describes how to configure and run Helpy on Kubernetes. Kubernetes is a container
orchistration tool that completely abstracts working with SSH or capistrano and makes
it trivial to run a cluster of Helpy instances.

#### Requirements

This implementation expects a couple things- that you will use a DBaaS such as Amazon AWS RDS or
similar services to run a Postgres database.  You should also set up S3 or a compatible
file store to save your users file attachments.

### 1. Copy env.yml.sample to env.yml

First make a production copy of the env.yml file and add your configuration values here.
Notably, you will need a database and file storage servrer like S3 or DigitalOcean spaces.

### 2. 

### 3. Run the initial migration to set up your database

Use `kubectl get pods` to get the name of one of your helpy pods.  Next, use the following command
to run the initial migration and seed:

`kubectl exec [your pod] bundle exec rake db:migrate`
`kubectl exec [your pod] bundle exec rake db:seed`