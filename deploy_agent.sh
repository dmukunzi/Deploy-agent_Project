#!/bin/bash 

set -u 

 if command -v python3; then 
    echo "Success: python3 is installed."
 else
    echo "Error: python3 is not installed."
    exit 1

 fi 

 if command -v zip; then 
    echo "Success: zip is installed."
 else 
    echo "Error: zip is not installed."
    exit 1
 fi 

 echo "Pre-flight checks passed: python3 and zip are installed."
