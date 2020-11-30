pipeline {
  agent any

   tools {nodejs "node"}
  
    environment {
      AWS_ACCESS_KEY_ID = credentials('awsAccessKey')
      AWS_SECRET_ACCESS_KEY = credentials('awsScretAccessKey')
      AWS_DEFAULT_REGION = 'ap-northeast-2'
      HOME = '.' // Avoid npm root owned
    }

  parameters {
    string(name: 'branch', defaultValue: 'master', description: 'git branch')
    string(name: 'url', defaultValue: 'git@github.com:wkdgus1164/react-typescript.git', description: 'git url')
  }

  stages {

    stage('Start') { 
      
      steps {      
        
        slackSend (channel: '#jenkins', color: '#000000',  message: "${env.JOB_NAME} 시작 : Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
    }
    
    stage('Clone'){
      
      steps{
        
        echo 'git clone'       
        git credentialsId: 'react-git',
          branch: "${params.branch}",
             url: "${params.url}"
      }

      post {
        success {
          echo 'successfully clone'
          slackSend (channel: '#jenkins', color: '#00FF00',  message: "Git clone 성공 : Git URL :${params.url} Branch : ${params.branch}")
        }
        
        failure {
          echo 'fail clone'
          slackSend (channel: '#jenkins', color: '#00FF00', message: "Git clone 실패 : Git URL :${params.url} Branch : ${params.branch}")
        }
      }
  }      
    
    stage('End') { 
      
      steps {        
        slackSend (channel: '#jenkins', color: '#000000',  message: "Jenkins 종료 : Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
      }
    }
    
  } 
}
