#!/bin/bash

#Name of the Job
JOB_NAME=

#Root folder where all the artifacts related to a execution are located.
WORK_FOLDER=

#Location of the PRECISION100 framework installtion: 
PRECISION100_FOLDER=

#The type of the repository to be used for the migration templates
#Supported values are GIT | FILE. Default[GIT] :
REPO_TYPE=GIT

#URL of the repository for migration templates.
#URL format must match the Repository type chosen above.
REPO_URL=

#Project Name of the migration template to be used.
PROJECT_NAME=

#Dataflow of the project that needs to be executed
DATAFLOW=

source $PRECISON100_FOLDER/conf/.env.sh

#Iteration to be run.
#This can be job name with the instance 
EXECUTION_NAME="$(date +%F-%H-%M-%S)"
PRECISION100_WORK_FOLDER="$WORK_FOLDER/$JOB_NAME/$EXECUTION_NAME"

source $PRECISION100_FOLDER/conf/.execution.env.sh

log_file_name="$PRECISION100_WORK_FOLDER/log/${DATAFLOW}-${EXECUTION_NAME}.out"
err_file_name="$PRECISION100_WORK_FOLDER/log/${DATAFLOW}-${EXECUTION_NAME}.err"
$PRECISION100_FOLDER/bin/exec_dataflow.sh ${DATAFLOW} 1> >(tee -a "$log_file_name") 2> >(tee -a "$err_file_name" >&2)

