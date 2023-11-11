from fastapi import FastAPI, Request
from pydantic import BaseModel

app = FastAPI()
class Text(BaseModel):
    text: str

