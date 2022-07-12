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
                     anyOf { branch 'feature/*'; branch 'develop' }
                 }
           steps {
		  dir('/home/dockuser/workspace') {
	      sh 'mkdir scmfolder'
		     }
           }
        }
        stage('Manual Checkout SCM in NEW workspace') {
		  when {
                   branch 'feature/*' 
                 }
           steps {
		    dir('/home/dockuser/workspace/scmfolder') {
	        checkout scm
	         sh "echo Git Commit: $GIT_COMMIT"
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
                     anyOf { branch 'feature/*'; branch 'fix*'; branch 'develop' }
                 }
                steps {
                    script {
	    		CI_ERROR = "Failed: Dependencies"
	    		CI_OK = "Success: Dependencies"
                sh '''#!/bin/bash -l
                nvm list
                nvm use $(cat .nvmrc) --install
		rvm use $(cat .ruby-version) --install
	    	     '''
                   }
                }
        }	 
	stage('Prepare') {
                 when {
                     anyOf { branch 'feature/*'; branch 'fix*'; branch 'develop' }
                 }
                steps {
                    script {
	    		CI_ERROR = "Failed: Prepare"
	    		CI_OK = "Success: Prepare"
                sh '''#!/bin/bash -l
                npm install -g yarn
		yarn install
	    	     '''
                   }
                }
         }
	 stage('Build') {
                 when {
                     anyOf { branch 'feature/*'; branch 'fix*'; branch 'develop' }
                 }
		 environment {
                   BUNDLER_VERSION = sh(script: 'awk "/BUNDLED WITH/{getline; print}" Gemfile.lock', returnStdout: true)
			 VERS = "${BUNDLER_VERSION}" 
			 
                }
                steps {
                    script {
	    		CI_ERROR = "Failed: Build"
	    		CI_OK = "Success: Build"
			    echo "yes 1"
	        echo "Bundle version is: ${BUNDLER_VERSION}"
			    echo "yes 2"
	
	        sh '''#!/bin/bash -l
		echo "yes 3"
	    	gem install bundler -v ${BUNDLER_VERSION}
		echo "yes 4"
		echo "Build full flag: "_$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'<<<"${VERS}")_""
		echo "yes 5"
		
	        bundle _$(sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'<<<"${VERS}")_ install
		 '''
                   }
                }
         }
	 stage('Prepare ENV') {
                 when {
                     anyOf { branch 'feature/*'; branch 'fix*'; branch 'develop' }
                 }
		 environment {
                  EXAMPLE_KEY = credentials('ENC-CONFIG-MASTER')
                }
                steps {
                    script {
	    		CI_ERROR = "Failed: Prepare ENV"
	    		CI_OK = "Success: Prepare ENV"
			  sh 'echo "${EXAMPLE_KEY}" > config/master.key'
                
                   }
                }
         }
	 stage('DB test') {
              when {
                   branch 'feature/*' 
                 }
            steps {
                script {
			    CI_ERROR = "Failed: DB Test"
			    CI_OK = "Success: DB Test"
                           sh '''#!/bin/bash -l
		         RAILS_ENV=development bundle exec rake db:create db:migrate --trace
                         '''
               }
            }
            post {
                  success {
	    	      slackSend color : "good", message: "Success - DB Test", channel: '#cicd'
                      }
	          failure{
                      slackSend color : "danger", message: "Failed - DB Test", channel: '#cicd'
                      }
                 }
         }
	 stage('Test') {
              when {
                   branch 'master' 
                 }
            steps {
                script {
			    CI_ERROR = "Failed: Test"
			    CI_OK = "Success: Test"
                           sh '''#!/bin/bash -l
		         RAILS_ENV=development bundle exec rake test --trace
                         '''
               }
            }
            post {
                  success {
	    	      slackSend color : "good", message: "Success - Test", channel: '#cicd'
                      }
	          failure{
                      slackSend color : "danger", message: "Failed - Test", channel: '#cicd'
                      }
                 }
         }
	 stage('Push') {
		  when {
                   branch 'feature/*' 
                 }
           steps {
		script {
		    dir('/home/dockuser/workspace/scmfolder') {
	             datetime = new Date().format("yyyy-MM-dd HH:mm:ss");
	             sh "echo Branch Name: $BRANCH_NAME"
	             sh ("""
                      git checkout HEAD
	              git status
	              git branch
                      git branch -a
	              ls
	              echo "${env.WORKSPACE}"
	              git checkout develop  
		      git pull origin $BRANCH_NAME
	              git status
	              git branch
                      git diff develop origin/develop
		       ls -lrth
		      git branch -a
		      echo Branch Name: $BRANCH_NAME
	              ls -lrth
	              echo "${env.WORKSPACE}"
		      git tag -a ${BUILD_TAG} -m '${datetime}'
                    git push origin develop --tags
                  echo "pushed the code"
                  echo "pulled the code"				 
                   """)
		     sh "echo Branch Name: $BRANCH_NAME"
		    }
		    }
                }
            }
	 stage('Deploy to Staging') {
              when {
                  branch 'develop'
                }
              steps {
		 script {
		   CI_ERROR = "Failed: Deploy to Staging"
		   CI_OK = "Success: Deploy to Staging"
	          dir('/home/dockuser/workspace/scmfolder') {
	         checkout scm
                  sh '''#!/bin/bash -l
		  git branch 
		  echo "11"
		  ls
		  git branch -a
		  echo "22"
		  git checkout develop
		  git branch
		  git diff develop origin/develop
		  echo "33"
		  ls -lrth
                   bundle exec cap staging deploy         
          	     ''' }
                  }
	      }
	      post {
                  success{
                      slackSend color : "good", message: "Deploy to staging environment successful", channel: '#cicd'
                  }
                  failure{
                      slackSend color : "danger", message: "Failed to deploy to staging environment, check the logs and confirm error", channel: '#cicd'
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


def getGitCommit() {
    git_commit = sh (
        script: 'git rev-parse HEAD',
        returnStdout: true
    ).trim()
    return git_commit
}

