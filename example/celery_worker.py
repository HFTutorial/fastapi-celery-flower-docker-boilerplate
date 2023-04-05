import os
from celery import Celery
from dotenv import load_dotenv
import example.celery_config as celery_config

load_dotenv()

if os.environ.get("WORK_ENV") == "dev":
    load_dotenv("local.env")
elif os.environ.get("WORK_ENV") == "uat":
    load_dotenv("uat.env")
else:
    load_dotenv()


celery = Celery(__name__)
celery.config_from_object(celery_config)


if not celery.conf.broker_url:
    raise ValueError('Broker URL not supplied')
if not celery.conf.result_backend:
    raise ValueError('Result Backend URL not supplied')


@celery.task(name='do_this_with_worker')
def do_this_with_worker():
    return 'Did it'
