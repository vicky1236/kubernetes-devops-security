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
      stage('SonarQube Analysis') {
	      steps {
		   def mvn = tool 'Default Maven';
		   withSonarQubeEnv() {
		   sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-bg"
		   }
	   }
  }

      stage("docker build and push"){ 
          steps {
             withDockerRegistry([credentialsId: "docker-hub", url: ""]){
		                sh 'printenv'
		                sh 'docker build -t bharathbg/numeric-app:""$GIT_COMMIT"" .' //docker build
		                sh 'docker push bharathbg/numeric-app:""$GIT_COMMIT""'
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
