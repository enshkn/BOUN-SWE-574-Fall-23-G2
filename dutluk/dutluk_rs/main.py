from fastapi import FastAPI, Request
from pydantic import BaseModel

import numpy as np

import gensim
from gensim.models import Word2Vec
from gensim.utils import simple_preprocess

app = FastAPI()
class Text(BaseModel):
    text: str

model_path = "rs-word-embedding-model.gz"
word2vec_model = gensim.models.KeyedVectors.load_word2vec_format(
    model_path, binary=True
)

@app.post("/vectorize")
async def vectorize(data: Text):
    # Extract the text from the JSON object
    text = data.text
    # Tokenize the text
    tokenized_text = simple_preprocess(text)
    # Initialize an empty array to store the vectors
    vectors = []
    # For each token in the tokenized text, get its vector
    for token in tokenized_text:
        if token in word2vec_model:
            vectors.append(word2vec_model[token])
    # If no vectors found, return an empty list
    if not vectors:
        return {"vectorized": []}
    avg_vector = np.mean(vectors, axis=0)
    return {"vectorized": avg_vector.tolist()}