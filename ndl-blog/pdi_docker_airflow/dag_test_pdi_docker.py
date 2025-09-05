from datetime import datetime, timedelta
import pendulum
from airflow import DAG
from airflow.operators.docker_operator import DockerOperator
from docker.types import Mount
from airflow.operators.dummy_operator import DummyOperator

##########################################################################
#            DEFINITION GLOBALE DU DAG                                   #
DAG_ID = 'test_pdi_docker'
DAG_NAME = 'Test Pdi Docker'
DAG_TAG = ["pdi","test",'docker']
DAG_TIMEOUT = 20
DAG_RETRY_DELAY = 1
DAG_RETRIES = 0

default_args = {
    'owner'                     : 'nicodl',
    'description'               : DAG_NAME,
    'depend_on_past'            : False,
    'start_date'                : datetime(2025, 9, 3),
    'email_on_failure'          : False,
    'email_on_retry'            : False,
    'retries'                   : DAG_RETRIES,
    'retry_delay'               : timedelta(minutes=DAG_RETRY_DELAY),
}

##########################################################################
#            DECLARATION DU DAG                                          #

with DAG(DAG_ID,
        dag_display_name = DAG_NAME,
        default_args = default_args,
        catchup = False,
        tags= DAG_TAG,
        schedule_interval = None, # https://crontab.cronhub.io/
        is_paused_upon_creation = True,
        max_active_runs=1,
        on_failure_callback=None,
        on_success_callback=None,
        dagrun_timeout=timedelta(minutes=DAG_TIMEOUT),
        ) as dag:

    ##########################################################################
    #            DECLARATION DES TASKS                                       #

    #---------------------------------------------------------------
    # Task 1 => test pdi 9.4 dans un container docker

    tache_pdi_docker = DockerOperator(
        task_id='tache_pdi_docker',
        image = 'account/repo:pdi94_v1',
        api_version='auto',
        mount_tmp_dir=False,
        auto_remove=True,
        command = 'bash -c "/opt/pdi/kitchen.sh -file=/app/test_pdi_docker.kjb -level=Basic"',
        cpus= 1, #cpu du container a modifier selon use case 
        mem_limit= '1g', #ram du container a modifier selon use case 
        priority_weight= 1,
        execution_timeout= timedelta(minutes=10),
        environment= {"PENTAHO_DI_JAVA_OPTIONS": "-Xms512m -Xmx512m"},  #ram pour la jvm a modifier selon use case
        docker_url='unix://var/run/docker.sock',
        network_mode="bridge",
        mounts=[Mount(source="/mnt/DossierTachePdi/test", target='/app', type='bind')],
        force_pull=False
    )
    
    #task    
    start_dag = DummyOperator(task_id='start')
    #task   
    end_dag = DummyOperator( task_id='end')


start_dag >> tache_pdi_docker >> end_dag