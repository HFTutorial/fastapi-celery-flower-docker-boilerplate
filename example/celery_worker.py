from celery import Celery


celery = Celery(__name__)
celery.config_from_object('celery_config')

@celery.task(name='do_this_with_worker')
def do_this_with_worker():
    return 'Did it'
