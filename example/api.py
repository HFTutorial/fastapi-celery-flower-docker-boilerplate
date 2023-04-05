from fastapi import FastAPI
from starlette.responses import JSONResponse
from example.celery_worker import do_this_with_worker

api = FastAPI()


@api.get("/test_fastapi")
async def test_fastapi():
    return {"message": "[ok] FastAPI is working"}


@api.get('/test_celery')
async def test_celery():
    task = do_this_with_worker.delay()
    return JSONResponse({"Result": task.get()})