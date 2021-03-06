#!/bin/bash

#channel
CHANNEL="SCHEDULED-JOB"

#Name of the Job
JOB_NAME="quick-demo"

#Location of the PRECISION100 framework installtion: 
#This must be an absolute path - not a relative one.
export PRECISION100_FOLDER=$(pwd)/precision100

#Root folder where all the artifacts related to a execution are located.
export PRECISION100_PROJECT_FOLDER=$HOME/precision100

#The type of the repository to be used for the migration templates
#Supported values are GIT | FILE. Default[GIT] :
export PRECISION100_PROJECT_REPO_TYPE=GIT

#URL of the repository for migration templates.
#URL format must match the Repository type chosen above.
#e.g. PRECISION100_PROJECT_REPO_URL="git@github.com:ennovatenow/precision-100-migration-templates.git"
export PRECISION100_PROJECT_REPO_URL="git@github.com:ennovatenow/precision-100-migration-templates.git"

#Project Name of the migration template to be used.
export PRECISION100_PROJECT_NAME=simple-demo

#Dataflow of the project that needs to be executed
DATAFLOW=dataflow-one

#Project conf folder, by default this is PRECIION100_PROJECT_FOLDER/conf
export PRECISION100_PROJECT_CONF_FOLDER="$PRECISION100_PROJECT_FOLDER/conf"

#Location of connection file, this file contains the connection details for the project
#by default it is $PRECISION100_CONF_FOLDER/.connections.env.sh
export PRECISION100_PROJECT_CONNECTION_FILE="$PRECISION100_PROJECT_CONF_FOLDER/.connections.env.sh"

#Name of the default connection, to be used when connection name is not explicitly provided.
export PRECISION100_PROJECT_DEFAULT_CONNECTION="PRECISION100_CONNECTION"

export PRECISION100_PROJECT_OPERATION_MODE="DEV"
export SIMULATION_MODE="FALSE"
export SIMULATION_SLEEP=1


if [ ! -d "${PRECISION100_PROJECT_CONF_FOLDER}" ]; then
  mkdir -p "${PRECISION100_PROJECT_CONF_FOLDER}"
fi

source $PRECISION100_FOLDER/conf/.env.sh

#Iteration to be run.
#This can be job name with the instance 
PRECISION100_EXECUTION_NAME="$(date +%F-%H-%M-%S)-${JOB_NAME}"
PRECISION100_EXECUTION_FOLDER="${PRECISION100_PROJECT_FOLDER}/${PRECISION100_EXECUTION_NAME}"

EXECUTION_PID_FILE="$PRECISION100_PROJECT_CONF_FOLDER/.execution.pid"
echo $PRECISION100_EXECUTION_NAME > "$EXECUTION_PID_FILE"

source $PRECISION100_FOLDER/conf/.execution.env.sh

mkdir -p "$PRECISION100_EXECUTION_LOG_FOLDER"
log_file_name="$PRECISION100_EXECUTION_LOG_FOLDER/init-exec-${PRECISION100_EXECUTION_NAME}.out"
err_file_name="$PRECISION100_EXECUTION_LOG_FOLDER/init-exec-${PRECISION100_EXECUTION_NAME}.err"

$PRECISION100_BIN_FOLDER/init-exec.sh 1> >(tee -a "$log_file_name") 2> >(tee -a "$err_file_name" >&2)

log_file_name="$PRECISION100_EXECUTION_LOG_FOLDER/${DATAFLOW}-${PRECISION100_EXECUTION_NAME}.out"
err_file_name="$PRECISION100_EXECUTION_LOG_FOLDER/${DATAFLOW}-${PRECISION100_EXECUTION_NAME}.err"
$PRECISION100_BIN_FOLDER/exec-dataflow.sh ${DATAFLOW} 1> >(tee -a "$log_file_name") 2> >(tee -a "$err_file_name" >&2)

rm -f $EXECUTION_PID_FILE
