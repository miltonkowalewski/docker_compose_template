#!/bin/bash

# Command Exemple: ./compose-template.sh file=docker-compose.template service_name=Python

# Functions
Help()
{
   # Display Help
   echo "Docker-compose file variables."
   echo
   echo "Syntax: docker-compose [file=docker-compose-path][key=value]"
   echo
   echo "[file=docker-compose-path] File path | Path"
   echo "  Ex.: file=../docker-compose.template"
   echo
   echo "[key=value] Key (String template) | Value (String to be replaced)"
   echo "  Ex.: service_name=Python"
   echo
}

Replace()
{
  sed -i "s/{{$1}}/$2/g" $3
}

ARG1=$(echo $1 | cut -f1 -d=)
if [[ ! $ARG1 == "file" ]]; then
  Help
  exit
fi

ARG_LENGTH=${#ARG1}
ARG_VALUE="${1:$ARG_LENGTH+1}"
cp -p $ARG_VALUE docker-compose.yml

for ARGUMENT in "$@"
do
  KEY=$(echo $ARGUMENT | cut -f1 -d=)
  KEY_LENGTH=${#KEY}
  VALUE="${ARGUMENT:$KEY_LENGTH+1}"
  Replace $KEY $VALUE docker-compose.yml
  export "$KEY"="$VALUE"
done
