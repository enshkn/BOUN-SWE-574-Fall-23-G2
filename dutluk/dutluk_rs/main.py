from fastapi import FastAPI, Request
from typing import List, Dict
import os
from fastapi import HTTPException
from appconfig import app_initializer
from classes import Story, UserInteraction, Recommend, DeleteStory, DeleteAllStory
from cf import story_parser, text_processor, tokenizer, upsert, weighted_vectorising, update_story_vector, \
    update_user_vector, user_like_unlike_parser, story_user_vectors_fetcher, list_to_nparray, like_story_operations, \
    unlike_story_operations, single_vector_fetcher, recommendation_parser, story_recommender, user_recommender, \
    list_to_string, \
    generate_id_with_prefix, generate_ids_with_prefix, parse_ids_with_prefix_for_lists, parse_id_with_prefix, \
    create_empty_float_list, upsert_for_empty_list, vector_fetcher, token_counter

app, index, word2vec_model = app_initializer()

"""
requests_list: List[Dict] = []

@app.middleware("http")
async def log_requests(request: Request, call_next):
    request_details = {
        "method": request.method,
        "url": str(request.url),
        "headers": dict(request.headers),
    }
    requests_list.append(request_details)

    response = await call_next(request)
    return response


@app.get("/monitor-requests")
async def get_requests():
    return requests_list
"""


@app.post("/vectorize")
async def vectorize(data: Story):
    return await process_vectorize(data)


@app.post("/vectorize-edit")
async def vectorize_edit(data: Story):
    return await process_vectorize_edit(data)


@app.post("/story-liked")
async def story_liked(data: UserInteraction):
    return await process_story_liked(data)


@app.post("/story-unliked")
async def story_unliked(data: UserInteraction):
    return await process_story_unliked(data)


@app.post("/recommend-story")
async def recommend_story(data: Recommend):
    return await process_recommend_story(data)


@app.post("/recommend-user")
async def recommend_user(data: Recommend):
    return await process_recommend_user(data)


@app.post('/delete-story')
async def delete_story(data: DeleteStory):
    try:
        story_id = data.storyId
        story_id_with_prefix = generate_id_with_prefix(vector_id=story_id, vector_type="story")
        index.delete(ids=[story_id_with_prefix])
        return f"the story vector with id : {story_id} is deleted."
    except Exception as e:
        # Log the exception for further debugging
        print(f"An error occurred in 'delete_story': {str(e)}")
        # Return an HTTP 500 Internal Server Error with a custom error message
        raise HTTPException(status_code=500, detail="Internal Server Error")


@app.post('/delete-all')
async def delete_all_story(data: DeleteAllStory):
    try:
        pass_word = data.passWord
        if pass_word == os.getenv('ADMIN_PASS'):
            index.delete(delete_all=True)
        else:
            return "you don't have privileges to delete db"
    except Exception as e:
        # Log the exception for further debugging
        print(f"An error occurred in 'delete_all_story': {str(e)}")
        # Return an HTTP 500 Internal Server Error with a custom error message
        raise HTTPException(status_code=500, detail="Internal Server Error")


async def process_vectorize(data: Story):
    try:
        # Extract the text from the JSON object
        vector_text, vector_ids, vector_tags, vector_type = Story.story_parser(data)
        # add prefix to vector_id according to the type ( u if user and s if story)
        vector_ids = generate_id_with_prefix(vector_id=vector_ids, vector_type=vector_type)
        # convert tags list to string for tokenization
        vector_tags = list_to_string(vector_tags)
        # Tokenize the text, NLP pre-process techniques are implemented with simple process function.
        tokenized_text, tokenized_tags = text_processor(vector_text=vector_text, vector_tags=vector_tags)
        # Initialize an empty array to store the vectors
        text_vectors = tokenizer(tokenized_text, word2vec_model)
        tag_vectors = tokenizer(tokenized_tags, word2vec_model)
        token_count = token_counter(text_vectors=text_vectors, tag_vectors=tag_vectors)
        # Vector operations with Numpy
        avg_vector = weighted_vectorising(text_weight=0.85, tag_weight=0.15, text_vector=text_vectors,
                                          tag_vector=tag_vectors)
        # upsert to the vector db
        is_upserted = upsert(final_text_vector=avg_vector, pinecone_index=index, vector_ids=vector_ids,
                             vector_type=vector_type, token_count=token_count)
        return {"vectorized": avg_vector.tolist(), "is_upserted": is_upserted}
    except Exception as e:
        # Log the exception for further debugging
        print(f"An error occurred in 'process_vectorize': {str(e)}")
        # Return an HTTP 500 Internal Server Error with a custom error message
        raise HTTPException(status_code=500, detail="Internal Server Error")


async def process_vectorize_edit(data: Story):
    try:
        # Extract the text from the JSON object
        vector_text, vector_ids, vector_tags, vector_type = story_parser(data)
        # add prefix to vector_id according to the type
        vector_ids = generate_id_with_prefix(vector_id=vector_ids, vector_type=vector_type)
        # convert tags list to string for tokenization
        vector_tags = list_to_string(vector_tags)
        # Tokenize the text, NLP pre-process techniques are implemented with simple process function.
        tokenized_text, tokenized_tags = text_processor(vector_text=vector_text, vector_tags=vector_tags)
        text_vectors = tokenizer(tokenized_text, word2vec_model)
        tag_vectors = tokenizer(tokenized_tags, word2vec_model)
        token_count = token_counter(text_vectors=text_vectors, tag_vectors=tag_vectors)
        # Vector operations with Numpy
        avg_vector = weighted_vectorising(text_weight=0.85, tag_weight=0.15, text_vector=text_vectors,
                                          tag_vector=tag_vectors)
        # upsert to the vector db
        is_upserted = upsert(final_text_vector=avg_vector, pinecone_index=index, vector_ids=vector_ids,
                             vector_type=vector_type, token_count=token_count)
        return {"vectorized": avg_vector.tolist(), "is_upserted": is_upserted}
    except Exception as e:
        # Log the exception for further debugging
        print(f"An error occurred in 'process_vectorize_edit': {str(e)}")
        # Return an HTTP 500 Internal Server Error with a custom error message
        raise HTTPException(status_code=500, detail="Internal Server Error")


async def process_story_liked(data: UserInteraction):
    try:
        """ user weight should be updated then received"""
        # parse the user and story attributes
        vector_type, story_id, user_id, user_weight = user_like_unlike_parser(data=data)
        # add prefix to vector_id according to the type
        story_id = generate_id_with_prefix(vector_id=story_id, vector_type="story")
        user_id = generate_id_with_prefix(vector_id=user_id, vector_type="user")

        response = None
        updated_user_vector = None

        if user_weight < 2:  # first like of a user
            story_vector = vector_fetcher(pinecone_index=index, vector_id=story_id, vector_type="story")
            user_vector = story_vector
            np_story_vector, np_user_vector = list_to_nparray(story_vector=story_vector, user_vector=user_vector)
            updated_user_vector = np_user_vector
            response = upsert(final_text_vector=updated_user_vector, pinecone_index=index, vector_ids=user_id,
                              vector_type="user")
        else:
            # fetch story and user vectors
            story_vector = vector_fetcher(pinecone_index=index, vector_id=story_id, vector_type="story")
            user_vector = vector_fetcher(pinecone_index=index, vector_id=user_id, vector_type="user")
            # python list to nparray
            np_story_vector, np_user_vector = list_to_nparray(story_vector=story_vector, user_vector=user_vector)
            # vector operations for story liking
            updated_user_vector = like_story_operations(np_story_vector=np_story_vector, np_user_vector=np_user_vector,
                                                        user_weight=user_weight)
            # update the vector
            response = update_user_vector(final_user_vector=updated_user_vector.tolist(), pinecone_index=index,
                                          vector_ids=user_id, vector_type="user")

        return {"return": response, "updated_vector": updated_user_vector.tolist()}
    except Exception as e:
        # Log the exception for further debugging
        print(f"An error occurred in 'process_story_liked': {str(e)}")
        # Return an HTTP 500 Internal Server Error with a custom error message
        raise HTTPException(status_code=500, detail="Internal Server Error")


async def process_story_unliked(data: UserInteraction):
    try:
        """ user weight should be updated then received"""
        # parse the user and story attributes
        vector_type, story_id, user_id, user_weight = user_like_unlike_parser(data=data)
        # add prefix to vector_id according to the type
        story_id = generate_id_with_prefix(vector_id=story_id, vector_type=vector_type)
        user_id = generate_id_with_prefix(vector_id=user_id, vector_type="user")
        # fetch story and user vectors
        story_vector = vector_fetcher(pinecone_index=index, vector_id=story_id, vector_type="story")
        user_vector = vector_fetcher(pinecone_index=index, vector_id=user_id, vector_type="user")
        # python list to nparray
        np_story_vector, np_user_vector = list_to_nparray(story_vector=story_vector, user_vector=user_vector)
        # vector operations for story unliking
        updated_user_vector = unlike_story_operations(np_story_vector=np_story_vector, np_user_vector=np_user_vector,
                                                      user_weight=user_weight)
        # update the vector
        response = update_user_vector(final_user_vector=updated_user_vector.tolist(), pinecone_index=index,
                                      vector_ids=user_id, vector_type=vector_type)
        return {"return": response, "updated_vector": updated_user_vector.tolist()}
    except Exception as e:
        # Log the exception for further debugging
        print(f"An error occurred in 'process_story_unliked': {str(e)}")
        # Return an HTTP 500 Internal Server Error with a custom error message
        raise HTTPException(status_code=500, detail="Internal Server Error")


async def process_recommend_story(data: Recommend):
    try:
        # parse the JSON
        user_id, excluded_ids, vector_type = recommendation_parser(data)
        # add prefix to vector_id according to the type
        user_id = generate_id_with_prefix(vector_id=user_id, vector_type="user")
        excluded_ids = generate_ids_with_prefix(vector_ids=excluded_ids, vector_type=vector_type)
        # fetch the user vector with its vector_id
        vector = single_vector_fetcher(pinecone_index=index, vector_id=user_id)
        print("this is test for single_vector_fetcher function:", vector)
        # parse ids of the recommended story and scores
        ids, scores = story_recommender(pinecone_index=index, user_vector=vector, excluded_ids=excluded_ids,
                                        vector_type=vector_type)
        ids = parse_ids_with_prefix_for_lists(vector_ids=ids)
        # parse ids for backend
        return {"ids": ids, "scores": scores}
    except Exception as e:
        # Log the exception for further debugging
        print(f"An error occurred in 'process_recommend_story': {str(e)}")
        # Return an HTTP 500 Internal Server Error with a custom error message
        raise HTTPException(status_code=500, detail="Internal Server Error")


async def process_recommend_user(data: Recommend):
    try:
        # parse the JSON
        user_id, excluded_ids, vector_type = recommendation_parser(data)
        # add prefix to vector_id according to the type
        user_id = generate_id_with_prefix(vector_id=user_id, vector_type="user")
        excluded_ids = generate_ids_with_prefix(vector_ids=excluded_ids, vector_type=vector_type)
        # fetch the user vector with its vector_id
        vector = single_vector_fetcher(pinecone_index=index, vector_id=user_id)
        # parse ids of the recommended story and scores
        ids, scores = user_recommender(pinecone_index=index, user_vector=vector, excluded_ids=excluded_ids,
                                       vector_type=vector_type)
        # parse ids for backend
        ids = parse_ids_with_prefix_for_lists(vector_ids=ids)
        return {"ids": ids, "scores": scores}
    except Exception as e:
        # Log the exception for further debugging
        print(f"An error occurred in 'process_recommend_user': {str(e)}")
        # Return an HTTP 500 Internal Server Error with a custom error message
        raise HTTPException(status_code=500, detail="Internal Server Error")


@app.get("/test")
async def test_page():
    return "<h1> Hello world </h1>"
