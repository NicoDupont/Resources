from datetime import datetime, timedelta
import pendulum
from airflow import DAG
from airflow.operators.docker_operator import DockerOperator
from docker.types import Mount
from airflow.operators.dummy_operator import DummyOperator

##########################################################################
#            IMPORTS VAR PERSO                                           #
import env.config as config
import env.env as env

##########################################################################
#            DEFINITION GLOBALE DU DAG                                   #
DAG_ID = 'test_hop_docker'
DAG_NAME = 'Test Hop Docker'
DAG_TAG = ["hop","test",'docker']
TIMEZONE = env.TIMEZONE
DAG_TIMEOUT = 20
DAG_RETRY_DELAY = 1
DAG_RETRIES = 0

DOCKER_IMAGE = env.HOP_DOCKER_IMAGE  #" = nom de l'image docker exemple : 'apache/hop:2.11.0'
DOCKER_RUN_LOCATION = 'ServerDev' # options : local  / ServerDev / ServerProd / env.HOP_SERVEUR
DOCKER_TIMEOUT = 10
DOCKER_CPU = 1
DOCKER_RAM = '512m' # 1g, 2g, etc...

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
    # Task 1 => test hop run location
    # Paramétrages
    HopConfigDocker = {
        'image': DOCKER_IMAGE,
        'cpus': DOCKER_CPU,
        'mem_limit': DOCKER_RAM,
        'log_level':'Basic',
        'workflow':'${PROJECT_HOME}/test_hop_docker.hwf',
        'priority_weight':config.PriorityWeight('normal'),
        'execution_timeout':timedelta(minutes=DOCKER_TIMEOUT),
        'project_name':'test_hop',
        'source_project':f'{env.HOP_DOCKER_BASE_MOUNT}/projets/test_hop',
        'source_config':f'{env.HOP_DOCKER_BASE_MOUNT}/config/',
        'source_jdbc': f'{env.HOP_DOCKER_BASE_MOUNT}/jdbc',
        'hop_conf':'/project-config/hop-config.json',
        'metadata': '/project-config/metadata.json',
        'jdbc': 'lib/jdbc,/jdbc',
        'api_url':'http://host.docker.internal:8000',
        'docker_url' : env.DOCKER_URL, # "tcp://host.docker.internal:2375 pour windows / linux : unix://var/run/docker.sock"
        'RUN_LOCATION' : DOCKER_RUN_LOCATION, # local / ServerDev / ServerProd
    }

    wkf_hop = DockerOperator(
        task_id='wkf_hop',
        image = HopConfigDocker['image'],
        api_version='auto',
        mount_tmp_dir=False,
        auto_remove=True,
        cpus= HopConfigDocker['cpus'],
        mem_limit= HopConfigDocker['mem_limit'],
        priority_weight= HopConfigDocker['priority_weight'],
        execution_timeout= HopConfigDocker['execution_timeout'],
        environment= {
            'HOP_RUN_PARAMETERS': f'INPUT_DIR=',
            'HOP_LOG_LEVEL': HopConfigDocker['log_level'],
            'HOP_OPTIONS' : '-XX:+AggressiveHeap',
            'HOP_FILE_PATH': HopConfigDocker['workflow'],
            'HOP_PROJECT_DIRECTORY': '/project',
            'HOP_PROJECT_NAME': HopConfigDocker['project_name'],
            'HOP_ENVIRONMENT_NAME': 'env-hop-airflow-sample.json',
            'HOP_ENVIRONMENT_CONFIG_FILE_NAME_PATHS': HopConfigDocker['hop_conf'],
            'HOP_RUN_CONFIG': HopConfigDocker['RUN_LOCATION'],
            'API_BASE_URL': HopConfigDocker['api_url'],
            'HOP_RUN_METADATA_EXPORT': HopConfigDocker['metadata'],
            'HOP_SHARED_JDBC_FOLDERS': HopConfigDocker['jdbc'],
        },
        docker_url=HopConfigDocker['docker_url'],
        network_mode="bridge",
        mounts=[Mount(source=HopConfigDocker['source_project'], target='/project', type='bind'),
                Mount(source=HopConfigDocker['source_config'], target='/project-config', type='bind'),
                Mount(source=HopConfigDocker['source_jdbc'], target='/jdbc', type='bind')
                ],
        force_pull=False
    )
    
        #task    
    start_dag = DummyOperator(task_id='start')
    #task   
    end_dag = DummyOperator( task_id='end')


start_dag >> wkf_hop >> end_dag