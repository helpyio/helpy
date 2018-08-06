#!groovy

// Variable declarations at top scope due to declarative structure
Object docker, deploy, version, git, logstashKeys
String repo = 'helpy'
String port = '8080'
String org = 'superpedestrian'
String credentialId = 'aws-eb-creds'
String installExtension = 'true'
String autoScaleUseELB = 'true'

// Production deployment vars
String ebApp, ver, activeEnv, newEnv

node {
  stage 'Clean and Checkout'
  checkout scm
  sh 'git submodule init && git submodule update --recursive'

  // Load up libraries
  docker = load 'jenkins_tools/groovy/docker.groovy'
  deploy = load 'jenkins_tools/groovy/deploy.groovy'
  version = load 'jenkins_tools/groovy/version.groovy'
  git = load 'jenkins_tools/groovy/git.groovy'
  logstashKeys = deploy.LOGSTASH_KEYS
}

pipeline {
  agent none
  stages {
    stage('Build Docker Image') {
      agent any
      steps {
        script {
          docker.dockerComposeBuild true
        }
      }
    }
    stage('Tests') {

    }
    stage('Deploy CI') {
      agent any
      when {
        branch 'master'
      }
      steps {
        script {
          ebApp = 'helpy-staging'
          docker.dockerTagPush repo, 'latest', env.BUILD_NUMBER
          env.LOGSTASH_DOC_TYPE = 'helpy_staging'
          deploy.ebDeploy(
            'helpy-staging',
            'helpy-staging-ci',
            '768',
            env.BUILD_NUMBER,
            port,
            repo,
            org,
            credentialId,
            installExtension,
            logstashKeys,
            autoScaleUseELB
          )
        }
      }
    }
    stage('Get new version') {
      agent any
      when {
        branch 'release'
      }
      steps {
        script {
          ver = version.pyVersion()
          currentBuild.displayName = ver
        }
      }
    }
    stage('Tag version and proceed?')
    {
      agent none
      when {
        branch 'release'
      }
      steps {
        input "Proceed with tagging of ${ver}?"
      }
    }
    stage('Production Release') {
      agent any
      when {
        branch 'release'
      }
      steps {
        script {
          git.gitTag ver, "Release ${ver}"
          docker.dockerTagPush repo, 'release', ver
          ebApp = 'helpy-production'
          activeEnv = ''
          newEnv = ''
          // Find current environment that holds the main cname
          activeEnv = deploy.ebGetActiveEnv(ebApp, 'helpy-prod-blue')
          if (activeEnv == 'helpy-prod-blue') {
            newEnv = 'helpy-prod-purple'
          } else {
            newEnv = 'helpy-prod-blue'
          }
          // Clone that environment to the off color one
          deploy.ebClone(ebApp, activeEnv, newEnv, 'helpy-prod-purple')
          env.LOGSTASH_DOC_TYPE = helpy_api_prod_${newEnv}"
          deploy.ebDeploy(
            ebApp,
            newEnv,
            '3072',
            ver,
            port,
            repo,
            org,
            credentialId,
            installExtension,
            logstashKeys,
            autoScaleUseELB
          )
        }
      }
    }
    stage('Promote?') {
      agent none
      when {
        branch 'release'
      }
      steps {
        input 'Already Run Migrations? Ready to promote https://tickets.superpedestrian.com?'
      }
    }
    stage('Swap URL') {
      agent any
      when {
        branch 'release'
      }
      steps {
        script {
          deploy.ebSwap(
            ebApp,
            newEnv,
            'helpy-prod-blue',
            'helpy-prod-purple'
          )
        }
      }
    }
    stage('Terminate old environment?') {
      agent none
      when {
        branch 'release'
      }
      steps{
        input "Ready to terminate old environment ${activeEnv} ?"
      }
    }
    stage('Terminating old environment') {
      agent any
      when {
        branch 'release'
      }
      steps {
        script {
          deploy.ebTerminate(ebApp, activeEnv)
        }
      }
    }
  }
  post {
    failure {
      mail body: "Why oh why did you break the beautiful Helpy build?!. For details check out ${env.BUILD_URL}",
        from: "ops-bot@superpedestrian.com",
        subject: "helpy cracked its skull on branch ${env.BRANCH_NAME}",
        to: 'dev@superpedestrian.com'
    }
  }
}
