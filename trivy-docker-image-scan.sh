#!/bin/bash

dockerImageName=$(awk 'NR==1 {print $2}' Dockerfile)
echo $dockerImage=Name

docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --serverity HIGH --light $dockerImageName
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --serverity CRITICAL --light $dockerImageName

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