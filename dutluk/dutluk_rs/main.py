import pinecone
from fastapi import FastAPI
from classes import Story, UserInteraction
from cf import story_parser, text_processor, tokenizer, upsert, weighted_vectorising, update_story_vector, update_user_vector, user_like_unlike_parser, story_user_vectors_fetcher, list_to_nparray, like_story_operations, unlike_story_operations
import numpy as np
import gensim
from gensim.models import Word2Vec
from gensim.utils import simple_preprocess
import os
from dotenv import load_dotenv

load_dotenv(".env")
app = FastAPI()
pinecone.init(os.getenv('PINECONE_API_KEY'), environment=os.getenv('ENVIRONMENT'))
index = pinecone.Index(os.getenv('PROJECT_INDEX'))
model_path = "rs-word-embedding-model.gz"
word2vec_model = gensim.models.KeyedVectors.load_word2vec_format(model_path, binary=True)


@app.post("/vectorize")
async def vectorize(data: Story):
    # Extract the text from the JSON object
    vector_text, vector_ids, vector_tags, vector_type = story_parser(data)
    # Tokenize the text, NLP pre-process techniques are implemented with simple process function.
    tokenized_text, tokenized_tags = text_processor(vector_text=vector_text, vector_tags=vector_tags)
    # Initialize an empty array to store the vectors
    text_vectors = tokenizer(tokenized_text, word2vec_model)
    tag_vectors = tokenizer(tokenized_tags, word2vec_model)
    # Vector operations with Numpy
    avg_vector = weighted_vectorising(text_weight=0.5, tag_weight=0.5, text_vector=text_vectors, tag_vector=tag_vectors)
    # upsert to the vector db
    is_upserted = upsert(final_text_vector=avg_vector, pinecone_index=index, vector_ids=vector_ids, vector_type=vector_type)
    return {"vectorized": avg_vector.tolist(), "is_upserted": is_upserted}


@app.post("/vectorize-edit")
async def vectorize_edit(data: Story):
    # Extract the text from the JSON object
    vector_text, vector_ids, vector_tags, vector_type = story_parser(data)
    # Tokenize the text, NLP pre-process techniques are implemented with simple process function.
    tokenized_text, tokenized_tags = text_processor(vector_text=vector_text, vector_tags=vector_tags)
    text_vectors = tokenizer(tokenized_text, word2vec_model)
    tag_vectors = tokenizer(tokenized_tags, word2vec_model)
    # Vector operations with Numpy
    avg_vector = weighted_vectorising(text_weight=0.5, tag_weight=0.5, text_vector=text_vectors, tag_vector=tag_vectors)
    print(type(avg_vector))
    print(type(avg_vector.tolist()))
    print(vector_type)
    # update the vector
    response = update_story_vector(final_text_vector=avg_vector.tolist(), pinecone_index=index, vector_ids=vector_ids, vector_type=vector_type)
    return response

@app.post("/story-liked")
async def story_liked(data: UserInteraction):
    """ userweight güncellenip öyle gelsin"""
    # parse the user and story attributes
    vector_type, story_id, user_id, user_weight = user_like_unlike_parser(data=data)
    # fetch story and user vectors
    story_vector, user_vector = story_user_vectors_fetcher(pinecone_index=index, story_id=story_id, user_id=user_id)
    # python list to nparray
    np_story_vector, np_user_vector = list_to_nparray(story_vector=story_vector, user_vector=user_vector)
    # vector operations for story liking
    updated_user_vector = like_story_operations(np_story_vector=np_story_vector, np_user_vector=np_user_vector, user_weight=user_weight)
    # update the vector
    response = update_user_vector(final_user_vector=updated_user_vector.tolist(), pinecone_index=index, vector_ids=user_id, vector_type=vector_type)
    return {"return": response}

@app.post("/story-unliked")
async def story_unliked(data: UserInteraction):
    """ userweight güncellenip öyle gelsin"""
    # parse the user and story attributes
    vector_type, story_id, user_id, user_weight = user_like_unlike_parser(data=data)
    # fetch story and user vectors
    story_vector, user_vector = story_user_vectors_fetcher(pinecone_index=index, story_id=story_id, user_id=user_id)
    # python list to nparray
    np_story_vector, np_user_vector = list_to_nparray(story_vector=story_vector, user_vector=user_vector)
    # vector operations for story unliking
    updated_user_vector = like_story_operations(np_story_vector=np_story_vector, np_user_vector=np_user_vector, user_weight=user_weight)
    # update the vector
    response = update_user_vector(final_user_vector=updated_user_vector.tolist(), pinecone_index=index, vector_ids=user_id, vector_type=vector_type)
    return {"return": response}



