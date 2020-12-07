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
        git credentialsId: 'customReact',
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
    
  stage('SonarQube'){
      
      environment {
        scannerHome = tool 'SonarQubeScanner'
      }
      
      steps {
        withSonarQubeEnv('SonarQubeServer') { // Will pick the global server connection you have configured
          
          sh 'npm i'
          echo 'SonarQube '
          sh '${scannerHome}/bin/sonar-scanner -X'
          
        }
      }
      
      post {
        success {
          echo 'Successfully SonarQube'
          slackSend (channel: '#jenkins', color: '#00FF00',  message: "SonarQube 성공 : SonarQube Success")
        }
        
        failure {
          echo 'Fail SonarQube'
          slackSend (channel: '#jenkins', color: '#00FF00', message: "SonarQube 실패 : SonarQube Fail")
        }
      }
      
    }
      
    
    
    
  stage('Static Build & Server S3 Upload') {
    parallel{
      
      stage('Static Build'){
        steps {
          echo 'Static Build' 
          dir ('./execute'){ 
            sh 'sh ./build.sh'
          }
        }

        post {
          success {
            echo 'successfully Build'
            slackSend (channel: '#jenkins', color: '#00FF00',  message: "npm bulid 성공 : npm run build Success")
          }

          failure {
            echo 'fail Build'
            slackSend (channel: '#jenkins', color: '#00FF00', message: "npm bulid 실패 : npm run build Fail")
          }
        }
      }
      
      stage('React Sever Upload'){
        steps {
          echo 'React npm Upload' 
            dir ('./execute'){ 
              sh 'sh ./ReactSeverUpload.sh'
            }
          }
        post {
          success {
            echo 'successfully React Sever Upload'
              slackSend (channel: '#jenkins', color: '#00FF00',  message: "React Server S3 업로드 성공 : React Sever Upload")
            }
        
          failure {
            echo 'fail React Sever Upload'
              slackSend (channel: '#jenkins', color: '#00FF00', message: "React Server S3 업로드 실패 : React Sever Upload")
          }
        }
      }
      
    }

  }
    
    stage('Static S3 Upload & ColdeDeploy'){
      parallel{
        
        stage('React Static Upload'){
          steps {
            echo 'React Static Build Upload'  
            dir ('./execute'){ 
              sh 'sh ./ReactStaticUpload.sh'
            }
          }          
             
          post {
            success {
              echo 'successfully React Static Upload'
              slackSend (channel: '#jenkins', color: '#00FF00',  message: "React build S3 업로드 성공 : React Static Upload")
            }
        
            failure {
              echo 'fail React Static Upload'
              slackSend (channel: '#jenkins', color: '#00FF00', message: "React build S3 업로드 실패 : React Static Upload")
            }
          }
        }
        
        stage('Deploy'){
          steps{
            dir('./execute/codeDeploy'){
              sh 'sh ./deploy.sh'
          } 
        }
      
          post {
            success {
              echo 'successfully Deploy'
              slackSend (channel: '#jenkins', color: '#00FF00',  message: "CodeDeploy 호출 성공")
            }
        
            failure {
              echo 'fail Deploy'
              slackSend (channel: '#jenkins', color: '#00FF00', message: "CodeDeploy 호출 실패")
            }
          }
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
