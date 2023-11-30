from fastapi import HTTPException
from appconfig import app_initializer
from classes import Story, UserInteraction, Recommend
from cf import story_parser, text_processor, tokenizer, upsert, weighted_vectorising, update_story_vector, \
    update_user_vector, user_like_unlike_parser, story_user_vectors_fetcher, list_to_nparray, like_story_operations, \
    unlike_story_operations, single_vector_fetcher, recommendation_parser, story_and_user_recommender, list_to_string, generate_id_with_prefix, parse_ids_with_prefix_for_lists,parse_id_with_prefix

app, index, word2vec_model = app_initializer()


@app.post("/vectorize")
async def vectorize(data: Story):
    # Extract the text from the JSON object
    vector_text, vector_ids, vector_tags, vector_type = story_parser(data)
    # add prefix to vector_id according to the type
    vector_ids = generate_id_with_prefix(vector_id=vector_ids, vector_type=vector_type)
    print(vector_ids)
    print(type(vector_ids))
    # convert tags list to string for tokenization
    vector_tags = list_to_string(vector_tags)
    # Tokenize the text, NLP pre-process techniques are implemented with simple process function.
    tokenized_text, tokenized_tags = text_processor(vector_text=vector_text, vector_tags=vector_tags)
    # Initialize an empty array to store the vectors
    text_vectors = tokenizer(tokenized_text, word2vec_model)
    tag_vectors = tokenizer(tokenized_tags, word2vec_model)
    # Vector operations with Numpy
    avg_vector = weighted_vectorising(text_weight=0.5, tag_weight=0.5, text_vector=text_vectors, tag_vector=tag_vectors)
    # upsert to the vector db
    is_upserted = upsert(final_text_vector=avg_vector, pinecone_index=index, vector_ids=vector_ids,
                         vector_type=vector_type)
    return {"vectorized": avg_vector.tolist(), "is_upserted": is_upserted}


@app.post("/vectorize-edit")
async def vectorize_edit(data: Story):
    # Extract the text from the JSON object
    vector_text, vector_ids, vector_tags, vector_type = story_parser(data)
    # add prefix to vector_id according to the type
    vector_ids = generate_id_with_prefix(vector_id=vector_ids, vector_type=vector_type)
    print(vector_ids)
    print(type(vector_ids))
    # convert tags list to string for tokenization
    vector_tags = list_to_string(vector_tags)
    # Tokenize the text, NLP pre-process techniques are implemented with simple process function.
    tokenized_text, tokenized_tags = text_processor(vector_text=vector_text, vector_tags=vector_tags)
    text_vectors = tokenizer(tokenized_text, word2vec_model)
    tag_vectors = tokenizer(tokenized_tags, word2vec_model)
    # Vector operations with Numpy
    avg_vector = weighted_vectorising(text_weight=0.5, tag_weight=0.5, text_vector=text_vectors, tag_vector=tag_vectors)
    # update the vector
    response = update_story_vector(final_text_vector=avg_vector.tolist(), pinecone_index=index, vector_ids=vector_ids,
                                   vector_type=vector_type)
    return {"vectorized": avg_vector.tolist()}


@app.post("/story-liked")
async def story_liked(data: UserInteraction):
    """ user weight should be updated  then received"""
    # parse the user and story attributes
    vector_type, story_id, user_id, user_weight = user_like_unlike_parser(data=data)
    # add prefix to vector_id according to the type
    story_id = generate_id_with_prefix(vector_id=story_id, vector_type=vector_type)
    user_id = generate_id_with_prefix(vector_id=user_id, vector_type="user")
    print(story_id, user_id)
    print(type(story_id), type(user_id))
    # fetch story and user vectors
    story_vector, user_vector = story_user_vectors_fetcher(pinecone_index=index, story_id=story_id, user_id=user_id)
    # python list to nparray
    np_story_vector, np_user_vector = list_to_nparray(story_vector=story_vector, user_vector=user_vector)
    # vector operations for story liking
    updated_user_vector = like_story_operations(np_story_vector=np_story_vector, np_user_vector=np_user_vector,
                                                user_weight=user_weight)
    # update the vector
    response = update_user_vector(final_user_vector=updated_user_vector.tolist(), pinecone_index=index,
                                  vector_ids=user_id, vector_type=vector_type)
    return {"return": response}


@app.post("/story-unliked")
async def story_unliked(data: UserInteraction):
    """ user weight should be updated  then received"""
    # parse the user and story attributes
    vector_type, story_id, user_id, user_weight = user_like_unlike_parser(data=data)
    # add prefix to vector_id according to the type
    story_id = generate_id_with_prefix(vector_id=story_id, vector_type=vector_type)
    user_id = generate_id_with_prefix(vector_id=user_id, vector_type="user")
    print(story_id, user_id)
    print(type(story_id), type(user_id))
    # fetch story and user vectors
    story_vector, user_vector = story_user_vectors_fetcher(pinecone_index=index, story_id=story_id, user_id=user_id)
    # python list to nparray
    np_story_vector, np_user_vector = list_to_nparray(story_vector=story_vector, user_vector=user_vector)
    # vector operations for story unliking
    updated_user_vector = unlike_story_operations(np_story_vector=np_story_vector, np_user_vector=np_user_vector,
                                                  user_weight=user_weight)
    # update the vector
    response = update_user_vector(final_user_vector=updated_user_vector.tolist(), pinecone_index=index,
                                  vector_ids=user_id, vector_type=vector_type)
    return {"return": response}


@app.post("/recommend-story")
async def recommend_story(data: Recommend):
    try:
        # parse the JSON
        user_id, excluded_ids, vector_type = recommendation_parser(data)
        # fetch the user vector with its vector_id
        vector = single_vector_fetcher(pinecone_index=index, vector_id=user_id)
        # parse ids of the recommended story and scores
        ids, scores = story_and_user_recommender(pinecone_index=index, user_vector=vector, excluded_ids=excluded_ids,
                                                 vector_type=vector_type)
        return {"ids": ids, "scores": scores}
    except Exception as e:
        # Log the exception for further debugging
        print(f"An error occurred: {str(e)}")
        # Return an HTTP 500 Internal Server Error with a custom error message
        raise HTTPException(status_code=500, detail="Internal Server Error")


@app.post("/recommend-user")
async def recommend_user(data: Recommend):
    try:
        # parse the JSON
        user_id, excluded_ids, vector_type = recommendation_parser(data)
        # fetch the user vector with its vector_id
        vector = single_vector_fetcher(pinecone_index=index, vector_id=user_id)
        # parse ids of the recommended story and scores
        ids, scores = story_and_user_recommender(pinecone_index=index, user_vector=vector, excluded_ids=excluded_ids,
                                                 vector_type=vector_type)
        return {"ids": ids, "scores": scores}
    except Exception as e:
        # Log the exception for further debugging
        print(f"An error occurred: {str(e)}")
        # Return an HTTP 500 Internal Server Error with a custom error message
        raise HTTPException(status_code=500, detail="Internal Server Error")
    
@app.get("/test")
async def test_page():
    return "<h1> Hello world </h1>"
