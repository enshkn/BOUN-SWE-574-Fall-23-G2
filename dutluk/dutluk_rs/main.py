import pinecone
from fastapi import FastAPI
from classes import Story, UserInteraction
from cf import story_parser, text_processor, tokenizer, upsert, weighted_vectorising, update_story_vector, update_user_vector
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
    vector_type = data.type
    story_id = data.storyId
    user_id = data.userId
    user_weight = data.userWeight
    story_response = index.fetch([story_id])
    story_vector = story_response['vectors'][story_id]['values']
    user_response = index.fetch([user_id])
    user_vector = user_response['vectors'][user_id]['values']
    np_story_vector = np.array(story_vector)
    np_user_vector = np.array(user_vector)
    updated_user_vector = ((np_user_vector * user_weight) + (np_story_vector * 1)) / (user_weight + 1)
    response = update_user_vector(final_user_vector=updated_user_vector.tolist(), pinecone_index=index, vector_ids=user_id, vector_type=vector_type)

    return {"return": response}



