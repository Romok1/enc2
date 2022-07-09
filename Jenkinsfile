pipeline {
	agent {
        label 'linux'
    }
    options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
    durabilityHint('PERFORMANCE_OPTIMIZED')
    disableConcurrentBuilds()
   }
    environment {
	     git_credential = "github-login1"
        aws_credential = "AWS-CRED-JENKINS-MYUSER"
        git_tool_name = "default"
        bucket = "jenkins.myuser"
        region = "eu-west-2"
	    S3_PATH = "jenkinscicd"
	    S3_PATHE = "testfolder/"
	    api_res_url = "https://${bucket}.${region}.amazonaws.com/${bucket}/${S3_PATH}"
        auth_res_url = "https://${bucket}.s3.${region}.amazonaws.com/${bucket}/${S3_PATH}"
        notify_t = "image upload to s3 bucket, in path ${S3_PATH}"
    }
    triggers {
        pollSCM 'H/5 * * * *'
    }
    stages {
        stage('Create NEW SCM workspace') {
		when {
                   branch 'master' 
                 }
           steps {
		  dir('/home/dockuser/workspace') {
	      sh 'mkdir scmfolder'
		     }
           }
        }
        stage('Manual Checkout SCM in NEW workspace') {
		  when {
                   branch 'master' 
                 }
           steps {
		    dir('/home/dockuser/workspace/scmfolder') {
	        checkout scm
	         getGitCommit()
		     sh "echo Branch Name: $BRANCH_NAME"
		     sh 'echo "$BRANCH_NAME branch checked out into scmfolder"'
		    }
                }
            }
	stage ('Start') {
               steps {
                slackSend (color: '#FFFF00', message: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
	           }
         }
	stage('Dependencies') {
                 when {
                     anyOf { branch 'feature/*'; branch 'master' }
                 }
                steps {
                    script {
	    		CI_ERROR = "Failed: Dependencies"
	    		CI_OK = "Success: Dependencies"
                sh '''#!/bin/bash -l
                nvm list
                nvm use $(cat .nvmrc) --install
	    	     '''
                   }
                }
         } 
	  
    }
    post {
        always {
	        script {
		      CONSOLE_LOG = "${env.BUILD_URL}/console"
	              BUILD_STATUS = currentBuild.currentResult
		      if (currentBuild.currentResult == 'SUCCESS') { CI_ERROR = "NA" }
	               }
		        sendSlackNotifcation()
	    
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true,
                    patterns: [[pattern: '**/*',  type: 'INCLUDE'], [pattern: '~/workspace/scmfolder', type: 'INCLUDE'],
 		    [pattern: '.propsfile', type: 'EXCLUDE']]) 
	           
		
	        deleteDir()
                   dir("${env.WORKSPACE}@tmp") {
                       deleteDir()
                                }
		           dir("/home/dockuser/workspace/scmfolder") {
                    deleteDir()
                    }
		           dir("/home/dockuser/workspace/scmfolder@tmp") {
                    deleteDir()
                   }
	          }
	   
    }
  
}




def sendSlackNotifcation() 
{ 
	if ( currentBuild.currentResult == "SUCCESS" ) {
		buildSummary = "Job:  ${env.JOB_NAME}\n Status: *SUCCESS*\n Description: *${CI_OK}* \n"

		slackSend color : "good", message: "${buildSummary}", channel: '#cicd'
		}
	else {
		buildSummary = "Job:  ${env.JOB_NAME}\n Status: *FAILURE*\n Error description: *${CI_ERROR}* \n"
		slackSend color : "danger", message: "${buildSummary}", channel: '#cicd'
		}
}
