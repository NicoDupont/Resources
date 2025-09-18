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
TIMEOUT=${10}
PARAMS=${11}

# contrôle du Timeout
START_TIME=$(date +%s)
TIMEOUT_SECONDS=$((TIMEOUT * 60))

echo "Log type : "$LOG_TYPE
echo "Timeout paramétré : "$TIMEOUT" minutes"
echo "Timeout en secondes : "$TIMEOUT_SECONDS" secondes"

# parametres pour la tache PDI
if [[ -n "$PARAMS" ]]; then
    echo "Paramètres fournis : "$PARAMS""
else
    echo "Paramètres non fournis"
fi

#pattern pour les regex
PATTERN_JOB_ID="<id>(.*?)<\/id>"
PATTERN_JOB_STATUS="<status_desc>(.*?)<\/status_desc>"
PATTERN_JOB_LOG="<result>(.*?)<\/result>"
PATTERN_JOB_LOG_HTML="<textarea(.*?)<\/textarea\>"
CARTE_SERVER_URL="http://${CARTE_USER}:${CARTE_PASSWORD}@${CARTE_HOSTNAME}:${CARTE_PORT}"

# construction de l'url pour lancer la tache pdi



URL="${CARTE_SERVER_URL}/kettle/executeJob/?job=file:///${PDI_JOB_PATH}&level=${PDI_LOG_LEVEL}"
# Ajouter le paramètre optionnel s'il est fourni
if [[ -n "$PARAMS" ]]; then
    URL="${URL}&${PARAMS}"
fi
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

#Stop de la tache
function stopPdiJob {
    curl -s "${CARTE_SERVER_URL}/kettle/stopJob/?name=${PDI_JOB_NAME}&id=${PDI_JOB_ID}&xml=Y"
    echo "--------------------------------------"
    echo "Tache PDI arrété -> timeout dépassé !!"
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
    # Récupération du status de la tache => pour ne pas killer en timeout si terminée
    PDI_JOB_STATUS=$(getPDIJobStatus)

    # Vérification durée d'exécution
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
    if [[ $ELAPSED_TIME -gt $TIMEOUT_SECONDS && ${PDI_JOB_STATUS} != 'Finished' ]]; then
        stopPdiJob
        PDI_JOB_STATUS="TIMEOUT" # on sort de la boucle avec cette valeur au prochain test
    fi

    echo "The PDI job status is: ${PDI_JOB_STATUS} -> Durée exécution : $((ELAPSED_TIME / 60)) minutes et $((ELAPSED_TIME % 60)) secondes"
    #echo "Temps écoulé : $((ELAPSED_TIME / 60)) minutes et $((ELAPSED_TIME % 60)) secondes"
    sleep ${SLEEP_INTERVAL_SECONDS}
done 

# afficher log xml ou html complet ou seulement la partie pdi
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

# Envoyer une erreur à airflow si status nok ou timeout
if [[ ${PDI_JOB_STATUS} == 'Finished' ]]; then
    echo "Task PDI Finished -> exit 0"
    exit 0
elif [[ ${PDI_JOB_STATUS} == 'TIMEOUT' ]]; then
    echo "!! Task PDI en Timeout -> exit 1 !!"
    exit 1
else
    echo "!! Task PDI en Erreur -> exit 1 !!"
    exit 1
fi
