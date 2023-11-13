from fastapi import FastAPI, Request
from pydantic import BaseModel

import numpy as np

import gensim
from gensim.models import Word2Vec
from gensim.utils import simple_preprocess

from sklearn.metrics.pairwise import cosine_similarity



app = FastAPI()
class Text(BaseModel):
    text: str

class TextSimilarity(BaseModel):
    text_1: str
    text_2: str

class VectorSimilarity(BaseModel):
    vector_1: list
    vector_2: list

model_path = "rs-word-embedding-model.gz"
word2vec_model = gensim.models.KeyedVectors.load_word2vec_format(
    model_path, binary=True
)

@app.post("/vectorize")
async def vectorize(data: Text):
    # Extract the text from the JSON object
    text = data.text
    # Tokenize the text, NLP pre-process techniques are implemented with simple process function.
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

@app.post("/text-similarity")
async def textSimilarity(data: TextSimilarity):
    story_1 = data.text_1
    story_2 = data.text_2

    tokenized_story_1 = simple_preprocess(story_1)
    vectors_1 = [word2vec_model[token] for token in tokenized_story_1 if token in word2vec_model]
    tokenized_story_2 = simple_preprocess(story_2)
    vectors_2 = [word2vec_model[token] for token in tokenized_story_2 if token in word2vec_model]

    # If no vectors found for either text, return 0 similarity
    if not vectors_1 or not vectors_2:
        return {"similarity": float(0.0)}

    # Calculate cosine similarity between the average vectors
    avg_vector_1 = np.mean(vectors_1, axis=0)
    avg_vector_2 = np.mean(vectors_2, axis=0)
    similarity_score = cosine_similarity([avg_vector_1], [avg_vector_2])[0][0]

    return {"similarity": float(similarity_score)}

@app.post("/vector-similarity")
async def vectorSimilarity(data: VectorSimilarity):
    vector_1 = list(data.vector_1)
    vector_2 = list(data.vector_2)

    if not vector_1 or not vector_2:
        return {"similarity": float(0.0)}

    avg_vector_1 = np.mean(vector_1, axis=0)
    avg_vector_2 = np.mean(vector_2, axis=0)
    similarity_score = cosine_similarity([avg_vector_1], [avg_vector_2])[0][0]

    return {"similarity": float(similarity_score)}



