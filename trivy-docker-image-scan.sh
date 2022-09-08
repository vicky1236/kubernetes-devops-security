#!/bin/bash

dockerImageName=$(awk 'NR==1 {print $2}' Dockerfile) ##--severity value 
echo $dockerImageName

docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity HIGH --light $dockerImageName
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity CRITICAL --light $dockerImageName

     # Trivy scan result processing
     exit_code=$?
     echo "Exit code : $exit_code"
     
     #check the scan results
     if [["${exit_code}" == 1]]; 
     then 
         echo "Image scanning failed. vulnerabilities found"
         exit 1;
     else
       echo "Image scanning passed. No vulnerabilities found"
     fi;