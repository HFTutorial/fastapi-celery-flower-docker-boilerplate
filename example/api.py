from fastapi import FastAPI
from starlette.responses import JSONResponse
from fastapi.security import OAuth2PasswordBearer

api = FastAPI()


@api.get("/test")
async def test_fastapi():
    return {"message": "[ok] FastAPI is working"}