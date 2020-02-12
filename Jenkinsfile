def branchFunction(branchIn) {
  branchOut = branchIn.replaceAll('/','-')
  branchOut = branchOut.replaceAll('_','-')
  branchOut = branchOut.replaceAll('\\.','-')
  branchOut = branchOut.toLowerCase()
  return branchOut
}
def String rbVersion(text) {
  Object matcher = readFile(text) =~ 'VERSION\\s+=\\s+\'(.+)\''
  matcher ? matcher[0][1] : null
}

node('EKS-Druid') {
  stage 'Clean and Checkout'
  checkout scm
  sh 'git submodule init && git submodule update --recursive'
}

pipeline {
  agent { label 'EKS-Druid' }
  environment {
      branch_ns = branchFunction(env.BRANCH_NAME)
      chart_name = "helpy"
      prod_chart_name = "helpy-prod"
      chart_folder = "helpy-chart"
      staging_ns = "staging"
      production_ns = "production"
      docker_image = "superpedestrian/helpy"
      buildVersion = rbVersion('config/environment.rb')
  }
  stages {
    stage('Build Image') {
      agent { label 'EKS-Druid' }
      environment {
        DOCKERHUB_CREDS     = credentials('dockerhub_cred')
        HELPY_USERNAME      = credentials('helpy_username')
        HELPY_PASSWORD      = credentials('helpy_password')
    }
      steps {
          sh 'docker build --build-arg HELPY_USERNAME=$HELPY_USERNAME --build-arg HELPY_PASSWORD=$HELPY_PASSWORD  -t $docker_image:$branch_ns .'
          sh 'docker push $docker_image:$branch_ns'
      }
    }
    stage('Test k8s') {
      agent { label 'EKS-Druid' }
      steps {
          sh 'kubectl get all'
        }
    }
    stage('Test Helm') {
      agent { label 'EKS-Druid' }
      steps {
          sh 'helm list'
      }
    }
    stage('Make Namespace') {
      agent { label 'EKS-Druid' }
      environment {
        DOCKERHUB_CREDS     = credentials('dockerhub_cred')
    }
      steps {
          sh 'kubectl create ns $branch_ns'
          sh 'kubectl create secret docker-registry dockercred --namespace=$branch_ns --docker-server=https://index.docker.io/v1/ --docker-username=spdevops --docker-password=$DOCKERHUB_CREDS'
          sh 'kubectl patch serviceaccount default -p "{\\\"imagePullSecrets\\\": [{\\\"name\\\": \\\"dockercred\\\"}]}" --namespace=$branch_ns'
      }
    }
    stage('Run Pods') {
        agent { label 'EKS-Druid' }
        steps {
            sh 'kubectl run postgres --namespace=$branch_ns --image=postgres:9.6.2 --port=5432 --expose=true'
            sh 'kubectl run $branch_ns --namespace=$branch_ns --image=$docker_image:$branch_ns --image-pull-policy=Always --port=8088 --env="DATABASE_URL=postgres://postgres@postgres:5432/postgres" --env="RAILS_ENV=test"'
        }
    }
/*    stage('Test') {
        agent { label 'EKS-Druid' }
        steps {
            sleep 120
            sh 'kubectl exec -it `kubectl get pods --namespace=$branch_ns | grep $branch_ns | cut -d " " -f1` --namespace=$branch_ns /helpy/test.sh'
        }
    }*/
    stage('Deploy CI') {
      agent { label 'EKS-Druid' }
      when {
        branch 'master'
      }
      steps {

          sh 'docker tag $docker_image:$branch_ns $docker_image:latest'
          sh 'docker push $docker_image:latest'
          sh 'helm upgrade $chart_name ./$chart_folder --install --recreate-pods --version $buildVersion --namespace $staging_ns --set=.Values.image.tag=latest'
      }
    }
    stage('Deploy HQ Release') {
      agent { label 'EKS-Druid' }
      when {
        branch 'hq-release'
      }
      steps {
        sh 'docker tag $docker_image:$branch_ns $docker_image:hq'
        sh 'docker push $docker_image:hq'
        sh 'helm upgrade $prod_chart_name ./$chart_folder --install --wait --version $buildVersion --namespace $production_ns --set=image.tag=hq'
      }
    }
    stage('Deploy Link Release') {
      agent { label 'eks-link' }
      when {
        branch 'link-release'
      }
      steps {
        sh 'docker tag $docker_image:$branch_ns $docker_image:$buildVersion'
        sh 'docker push $docker_image:$buildVersion'
        sh 'helm upgrade $prod_chart_name ./$chart_folder --install --version $buildVersion --namespace $production_ns --set=image.tag=$buildVersion'
      }
    }
  }
  post {
    always {
      node('EKS-Druid') {
        sh 'kubectl delete ns $branch_ns || true'
      }
    }
    failure {
      mail body: "Oh no, Helpy needs help! For details check out ${env.BUILD_URL}",
        from: "ops-bot@superpedestrian.com",
        subject: "helpy is struggling on branch ${env.BRANCH_NAME}",
        to: 'dev@superpedestrian.com'
    }
  }
}

