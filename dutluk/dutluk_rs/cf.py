import pinecone
from classes import Story, UserInteraction
from gensim.utils import simple_preprocess
import numpy as np


def story_parser(data: Story):
    vector_text = data.text
    vector_ids = data.ids
    vector_tags = data.tags
    vector_type = data.type
    return vector_text, vector_ids, vector_tags, vector_type


def text_processor(vector_text, vector_tags):
    tokenized_text = simple_preprocess(vector_text)
    tokenized_tags = simple_preprocess(vector_tags)
    return tokenized_text, tokenized_tags


def tokenizer(tokenized, model):
    # Initialize an empty array to store the vectors
    vectors = []
    # For each token in the tokenized text, get its vector
    for token in tokenized:
        if token in model:
            vectors.append(model[token])
    # If no vectors found, return an empty list
    if not vectors:
        return {"vectorized_text": []}
    return vectors


def upsert(final_text_vector, pinecone_index, vector_ids, vector_type):
    pinecone_vector = final_text_vector.tolist()
    pinecone_index.upsert(
        vectors=[
            {
                "id": vector_ids,
                "values": pinecone_vector,
                "metadata": {"id": vector_ids, "type": vector_type},
            }
        ]
    )
    return True


def weighted_vectorising(text_weight, tag_weight, text_vector, tag_vector):
    # convert the lists into a vector, this makes two vectors same shape
    text_vector_np = np.mean(text_vector, axis=0)
    tag_vector_np = np.mean(tag_vector, axis=0)
    # multiply the vectors with its weights
    weighted_text_vectors = text_weight * text_vector_np
    weighted_tag_vectors = tag_weight * tag_vector_np
    # turn vectors to np array
    weighted_avg_text_vector = np.array(weighted_text_vectors)
    weighted_avg_tag_vector = np.array(weighted_tag_vectors)
    # merge two vectors
    weighted_avg_vector = weighted_avg_text_vector + weighted_avg_tag_vector
    return weighted_avg_vector


def update_story_vector(final_text_vector, pinecone_index, vector_ids, vector_type):
    update_response = pinecone_index.update(
        id=vector_ids,
        values=final_text_vector,
        set_metadata={"id": vector_ids, "type": vector_type}
    )
    return update_response


def update_user_vector(final_user_vector, pinecone_index, vector_ids, vector_type):
    update_response = pinecone_index.update(
        id=vector_ids,
        values=final_user_vector,
        set_metadata={"id": vector_ids, "type": vector_type}
    )
    return update_response


def user_like_unlike_parser(data: UserInteraction):
    vector_type = data.type
    story_id = data.storyId
    user_id = data.userId
    user_weight = data.userWeight
    return vector_type, story_id, user_id, user_weight


def story_user_vectors_fetcher(pinecone_index, story_id, user_id):
    story_response = pinecone_index.fetch([story_id])
    user_response = pinecone_index.fetch([user_id])
    user_vector = user_response['vectors'][user_id]['values']
    story_vector = story_response['vectors'][story_id]['values']
    return story_vector, user_vector


def list_to_nparray(story_vector, user_vector):
    np_story_vector = np.array(story_vector)
    np_user_vector = np.array(user_vector)
    return np_story_vector, np_user_vector

def like_story_operations(np_user_vector,np_story_vector, user_weight):
    updated_user_vector = ((np_user_vector * (user_weight - 1)) + np_story_vector) / user_weight
    return updated_user_vector

def unlike_story_operations(np_user_vector,np_story_vector, user_weight):
    updated_user_vector = ((np_user_vector * (user_weight + 1)) - np_story_vector) / user_weight
    return updated_user_vector
