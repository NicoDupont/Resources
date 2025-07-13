from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago
from datetime import datetime, timedelta
import pendulum


##########################################################################
# PARAMÈTRES
NOMBRE_MOIS_A_CONSERVER = 1
NOMBRE_JOUR_A_CONSERVER = NOMBRE_MOIS_A_CONSERVER*30
print(f"Nombre de mois à conserver : {NOMBRE_MOIS_A_CONSERVER}")
print(f"Nombre de jours à conserver : {NOMBRE_JOUR_A_CONSERVER}")

##########################################################################
# CALCUL DE LA DATE LIMITE
now = pendulum.now()
clean_before = now.subtract(months=NOMBRE_MOIS_A_CONSERVER)
clean_before_str = clean_before.format("YYYY-MM-DDTHH:mm:ss")

DAG_ID = 'cleaning'
DAG_NAME = 'Maintenance Db et Log'
DAG_TAG = ["maintenance","db","log"]
TIMEZONE = env.TIMEZONE

default_args_dag = {
    'owner'                     : 'ndl',
    'description'               : DAG_NAME,
    'depend_on_past'            : False,
    'start_date'                : datetime(2025, 5, 5), #pendulum.today(TIMEZONE).add(days=-1),  # annee / mois / jour
    'email_on_failure'          : False,
    'email_on_retry'            : False,
    'retries'                   : 0,
    'retry_delay'               : timedelta(minutes=1),
    'dagrun_timeout'            : timedelta(minutes=300),
}

with DAG(DAG_ID,
         dag_display_name=DAG_NAME,
         default_args=default_args_dag,
         catchup=False,
         tags=DAG_TAG,
         schedule_interval=None,#"3 10 * * 1-5", # https://crontab.cronhub.io/
         is_paused_upon_creation=True,
         on_failure_callback=failure_callbacks,
         on_success_callback=None,
         max_active_runs=1,
         ) as dag:

    clean_db = BashOperator(
        task_id="clean_db",
        bash_command=f"airflow db clean --clean-before-timestamp {clean_before_str} --yes",
    )

    clean_logs = BashOperator(
        task_id="delete_log_files",
        bash_command=(
        "for f in $(find $AIRFLOW_HOME/logs -type f -mtime +{{ params.jours }}); do "
        "echo \"Suppression de : $f\"; rm -f \"$f\"; "
        "done"
        ),
        params={"jours": NOMBRE_JOUR_A_CONSERVER},
    )

    clean_folders = BashOperator(
        task_id="delete_empty_folders",
        bash_command=(
            "echo 'Dossiers vides supprimés :' && "
            "find $AIRFLOW_HOME/logs -type d -empty -print -delete"
        ),
    )

clean_db >> clean_logs >> clean_folders