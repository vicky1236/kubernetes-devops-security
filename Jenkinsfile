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
      stage("docker build and push"){ 
          steps {
             withDockerRegistry([credentialsId: "docker-hub", url: ""]){
		                sh 'printenv'
		                sh 'docker build -t bharathbg/numeric-app:""$GIT_COMMIT"" .' //docker build
		                sh 'docker push bharathbg/numeric-app:""$GIT_COMMIT""'
		            }
          }
	  }
    }
}
