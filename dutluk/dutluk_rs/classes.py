from pydantic import BaseModel
class Text(BaseModel):
    text: str
    ids: str
    tags: str
    type: str

class TextSimilarity(BaseModel):
    text_1: str
    text_2: str

class VectorSimilarity(BaseModel):
    vector_1: list
    vector_2: list