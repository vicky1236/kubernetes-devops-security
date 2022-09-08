pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they 
            }
        }  
      stage('unit test') {
            steps {
              sh "mvn test"
              }
            post{
               always {
                 junit 'target/surefire-reports/*.xml'
                 jacoco execPattern: 'target/jacoco.exec'
                  }
            }
        } 
      stage('SonarQube - SAST') {
            steps {
               sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.host.url=http://devsecops-bg.centralus.cloudapp.azure.com:9000 -Dsonar.login=sqp_2d43d3f6c9b77bb28a159ebbb4948702e5aa564d"
            }
         } 
      stage("Vulnerability Scan -Docker"){
            steps {
               sh "mvn dependency-check:check"
               }
               post {
                 always {
                    dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
                    }
                }
              }
      stage("trivy scan"){
        steps{
          sh "bash trivy-docker-image-scan.sh"
        }
      }
      stage("docker build and push"){ 
          steps {
             withDockerRegistry([credentialsId: "docker-hub", url: ""]){
		                sh 'printenv'
		                sh 'sudo docker build -t bharathbg/numeric-app:""$GIT_COMMIT"" .' //docker build dockerhub
		                sh 'sudo docker push bharathbg/numeric-app:""$GIT_COMMIT""'    //modified the login
		            }
          }
	  }
      stage('k8 deployment -DEV') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig']) {
                sh "sed -i 's#replace#bharathbg/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
                sh "kubectl apply -f k8s_deployment_service.yaml"
             }
           }
         }
    }
}
