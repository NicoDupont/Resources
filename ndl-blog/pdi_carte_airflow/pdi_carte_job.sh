#!/bin/bash

# Passage de parametre depuis le dag
CARTE_USER=$1    
CARTE_PASSWORD=$2
CARTE_HOSTNAME=$3
CARTE_PORT=$4
PDI_JOB_PATH=$5
PDI_JOB_NAME=$6
PDI_LOG_LEVEL=$7
SLEEP_INTERVAL_SECONDS=$8
LOG_TYPE=$9
echo "Log type : "$LOG_TYPE

#pattern pour les regex
PATTERN_JOB_ID="(.*?)<\/id>"
PATTERN_JOB_STATUS="(.*?)<\/status_desc>"
PATTERN_JOB_LOG="(.*?)<\/result>"
PATTERN_JOB_LOG_HTML=""
CARTE_SERVER_URL="http://${CARTE_USER}:${CARTE_PASSWORD}@${CARTE_HOSTNAME}:${CARTE_PORT}"

# construction de l'url pour lancer la tache pdi
URL="${CARTE_SERVER_URL}/kettle/executeJob/?job=file:///${PDI_JOB_PATH}&level=${PDI_LOG_LEVEL}"
echo "Url envoyée au server pdi : "
echo $URL

# commande curl vers le serveur pdi
PDI_JOB_RES=$(curl -s "${URL}" | tr -d "\r\n")
#echo "Reponse du server pdi : " $PDI_JOB_RES

if [[ $PDI_JOB_RES =~ $PATTERN_JOB_ID ]]; then
  PDI_JOB_ID=${BASH_REMATCH[1]}
else
  PDI_JOB_ID="no found job id"
fi
#echo "recherche id : " $BASH_REMATCH
#echo "The PDI job ID is: " $PDI_JOB_ID

function getPDIJobStatus {
  STATUS=$(curl -s "${CARTE_SERVER_URL}/kettle/jobStatus/?name=${PDI_JOB_NAME}&id=${PDI_JOB_ID}&xml=Y" | tr -d "\r\n")
  #echo 'resultat status job : '$STATUS
  if [[ $STATUS =~ $PATTERN_JOB_STATUS ]]; then
    JOB_STATUS=${BASH_REMATCH[1]}
  else
    JOB_STATUS="no found job status"
  fi
  echo $JOB_STATUS
}

#log du server
function getPDIJobFullLog {
  LOG=$(curl -s "${CARTE_SERVER_URL}/kettle/jobStatus/?name=${PDI_JOB_NAME}&id=${PDI_JOB_ID}&xml=Y")
  echo $LOG
}

#log de la tache + transformation
function getPDIJobFullLogHtml {
  LOG=$(curl -s "${CARTE_SERVER_URL}/kettle/jobStatus/?name=${PDI_JOB_NAME}&id=${PDI_JOB_ID}")
  if [[ $LOG =~ $PATTERN_JOB_LOG_HTML ]]; then
    HTML_LOG=${BASH_REMATCH[0]}
  else
    HTML_LOG="no found job status"
  fi
  echo $HTML_LOG
}

#log de la transformation ???
function getPDIJobLog {
  LOG=$(curl -s "${CARTE_SERVER_URL}/kettle/jobStatus/?name=${PDI_JOB_NAME}&id=${PDI_JOB_ID}&xml=Y" | tr -d "\r\n")
  echo 'resultat log job : '$LOG
  if [[ $LOG =~ $PATTERN_JOB_LOG ]]; then
    JOB_LOG=${BASH_REMATCH[1]}
  else
    JOB_LOG="no found job log"
  fi
  echo $JOB_LOG
}

echo "Tache PDI : " $PDI_JOB_PATH
echo "PDI job ID : " $PDI_JOB_ID
echo "PDI server url : ${CARTE_SERVER_URL}/kettle/status/" 
echo "PDI server url pour ce job : ${CARTE_SERVER_URL}/kettle/jobStatus/?name=${PDI_JOB_NAME}&id=${PDI_JOB_ID}" 

# loop as long as the job is running
PDI_JOB_STATUS=$(getPDIJobStatus)
echo "Status du Job -> " $PDI_JOB_STATUS
while [[ $PDI_JOB_STATUS == "Running" || $PDI_JOB_STATUS == "Waiting" ]]
do
  PDI_JOB_STATUS=$(getPDIJobStatus)
  echo "The PDI job status is: " ${PDI_JOB_STATUS}
  #echo "I'll check in ${SLEEP_INTERVAL_SECONDS} seconds again"
  # check every x seconds
  sleep ${SLEEP_INTERVAL_SECONDS}
done 

# afficher log xml ou html complet ou seulement la partie pdi
#echo "The PDI job status is: " ${PDI_JOB_STATUS}
if [[ $LOG_TYPE == 'FULL' ]]; then
  echo "Full log ..."
  echo ""
  #echo $(getPDIJobFullLog)
  echo $(getPDIJobFullLogHtml)
else
  echo "Pdi log ..."
  echo ""
  echo $(getPDIJobLog)
fi

sleep 1

# Envoyer une erreur à airflow si status nok
if [[ ${PDI_JOB_STATUS} == 'Finished' ]]; then
  echo "Task Finished -> exit 0"
  exit 0
else
  echo "Task Error -> exit 1"
  exit 1
fi