from datetime import datetime, timedelta
import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator

import env.config as config
import env.env as env

default_args = { 
'owner'                     : 'nicolas-dupont',
'description'               : 'Test Carte PDI Curl',
'depend_on_past'            : False,
'start_date'                : pendulum.today(config.TIMEZONE).add(days=-1),  # annee / mois / jour
'email_on_failure'          : False,
'email_on_retry'            : False,
'retries'                   : 0,
'retry_delay'               : timedelta(minutes=5),
'dagrun_timeout'            : timedelta(minutes=5),
}

with DAG('bash_curl_carte_pdi',
        dag_display_name='Test Carte PDI Curl',
        default_args=default_args,
        catchup=False,
        tags=["pdi","test","carte","9.4","remote"],
        schedule_interval=None,
        is_paused_upon_creation=True,
        max_active_runs=1,
        on_failure_callback=None,
        ) as dag:

        BashPdiCarteJob = {'USERNAME':env.PDI_SERVEUR_USER,
                        'PASSWORD':env.PDI_SERVEUR_PASSWORD,
                        'HOSTNAME': env.PDI_SERVEUR,
                        'PORT':env.PDI_SERVEUR_PORT,
                        'JOB_PATH':f'{env.PDI_BASE_PATH}test/test_pdi_carte.kjb',
                        'JOB_NAME':'test_pdi_carte',
                        'LOG_LEVEL':'Basic',
                        'SLEEP_INTERVAL':'5',
                        'LOG_RETURN':'FULL' #full or pdi
                        'TIMEOUT':'1', # en minute
                        'PARAMS','param1=value1' #param1=value1¶m2=value2¶m3=value3
                        }
    

        curl_carte_pdi = BashOperator(task_id='curl_carte_pdi',
                                bash_command=f'bash /dags/scripts/pdi_carte_job_v3.sh {BashPdiCarteJob['USERNAME']} {BashPdiCarteJob['PASSWORD']} {BashPdiCarteJob['HOSTNAME']} {BashPdiCarteJob['PORT']} {BashPdiCarteJob['JOB_PATH']} {BashPdiCarteJob['JOB_NAME']} {BashPdiCarteJob['LOG_LEVEL']} {BashPdiCarteJob['SLEEP_INTERVAL']} {BashPdiCarteJob['LOG_RETURN']} {BashPdiCarteJob['TIMEOUT']} {BashPdiCarteJob['PARAMS']} '
                               )

curl_carte_pdi