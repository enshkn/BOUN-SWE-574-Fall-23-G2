import os
from fastapi import FastAPI
from dotenv import load_dotenv
import pinecone
import gensim
from gensim.models import Word2Vec


def app_initializer():
    load_dotenv(".env")
    app = FastAPI()
    pinecone.init(os.getenv('PINECONE_API_KEY'), environment=os.getenv('ENVIRONMENT'))
    index = pinecone.Index(os.getenv('PROJECT_INDEX'))
    model_path = "rs-word-embedding-model.gz"
    word2vec_model = gensim.models.KeyedVectors.load_word2vec_format(model_path, binary=True)
    return app, index, word2vec_model
