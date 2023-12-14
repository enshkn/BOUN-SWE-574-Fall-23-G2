from classes import Story, UserInteraction, Recommend
from gensim.utils import simple_preprocess
import numpy as np


def list_to_string(parameters_list: list):
    combined_string = ' '.join(map(str, parameters_list))
    return combined_string


def generate_id_with_prefix(vector_id, vector_type):
    if vector_type == "user":
        prefix = "u"
    elif vector_type == "story":
        prefix = "s"
    else:
        raise ValueError("Invalid vector_type value. Only 'user' or 'story' is accepted.")
    return f"{prefix}{vector_id}"


def generate_ids_with_prefix(vector_ids, vector_type):
    if vector_type == "user":
        prefix = "u"
    elif vector_type == "story":
        prefix = "s"
    else:
        raise ValueError("Invalid vector_type value. Only 'user' or 'story' is accepted.")

    return [f"{prefix}{vector_id}" for vector_id in vector_ids]


def parse_id_with_prefix(vector_id):
    if vector_id[0] == "u":
        vector_type = "user"
    elif vector_id[0] == "s":
        vector_type = "story"
    else:
        raise ValueError("Invalid vector_type value. Only 'user' or 'story' is accepted.")
    try:
        id_value = str(vector_id[1:])
    except ValueError:
        raise ValueError("Invalid vector_type value.")
    return id_value


def parse_ids_with_prefix_for_lists(vector_ids):
    parsed_results = []

    for vector_id in vector_ids:
        if vector_id[0] == "u":
            vector_type = "user"
        elif vector_id[0] == "s":
            vector_type = "story"
        else:
            raise ValueError("Invalid vector_type value. Only 'user' or 'story' is accepted.")
        try:
            id_value = int(vector_id[1:])
        except ValueError:
            raise ValueError("Invalid vector_type value. An integer is accepted.")

        parsed_results.append(id_value)

    return parsed_results


def story_parser(data: Story):
    vector_text = data.text
    vector_ids = data.ids
    vector_tags = data.tags
    vector_type = data.type
    return vector_text, vector_ids, vector_tags, vector_type


def text_processor(vector_text, vector_tags):
    """
    Processes text and tags by tokenizing them using the simple_preprocess function.

    Parameters:
    - vector_text (str): The text to be tokenized.
    - vector_tags (str): The tags to be tokenized.

    Returns:
    - tuple: A tuple containing tokenized_text and tokenized_tags.

    This function tokenizes the input text and tags using the simple_preprocess function from gensim.
    """

    try:
        tokenized_text = simple_preprocess(vector_text)
        tokenized_tags = simple_preprocess(vector_tags)
        return tokenized_text, tokenized_tags

    except Exception as e:
        print(f"Error in text_processor function: {e}")
        # Re-raise the exception to propagate it further if needed
        raise


def tokenizer(tokenized, model):
    """
    Tokenizes text and retrieves vectors for each token using a provided model.

    Parameters:
    - tokenized (list): A list of tokens obtained from text processing.
    - model: The model used for vectorization.

    Returns:
    - list: A list containing vectors for each token.

    This function tokenizes input tokens and retrieves their vectors using a provided model.
    :type tokenized: object
    """

    try:
        vectors = []
        for token in tokenized:
            if token in model:
                vectors.append(model[token])

        if not vectors:
            return {"vectorized_text": []}

        return vectors

    except Exception as e:
        print(f"Error in tokenizer function: {e}")
        # Re-raise the exception to propagate it further if needed
        raise


def upsert(final_text_vector, pinecone_index, vector_ids, vector_type):
    """
    Upserts vectors into a Pinecone index.

    Parameters:
    - final_text_vector (numpy.ndarray): The vector to be upserted into the index.
    - pinecone_index: The Pinecone index object.
    - vector_ids: The ID(s) associated with the vector.
    - vector_type: The type associated with the vector.

    Returns:
    - bool: True if the upsert operation is successful.

    This function upserts a vector into a Pinecone index with associated metadata.
    """

    try:
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

    except Exception as e:
        print(f"Error in upsert function: {e}")
        # Re-raise the exception to propagate it further if needed
        raise


def upsert_for_empty_list(final_text_vector, pinecone_index, vector_ids, vector_type):
    pinecone_vector = final_text_vector
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
    """
    Calculates weighted average vectors from given text and tag vectors.

    Parameters:
    - text_weight (float): The weight for text vectors.
    - tag_weight (float): The weight for tag vectors.
    - text_vector (list): List of text vectors.
    - tag_vector (list): List of tag vectors.

    Returns:
    - np.array: Weighted average vector obtained from text and tag vectors.

    This function calculates a weighted average vector using text and tag vectors with respective weights.
    """

    try:
        text_vector_np = np.mean(text_vector, axis=0)
        tag_vector_np = np.mean(tag_vector, axis=0)

        weighted_text_vectors = text_weight * text_vector_np
        weighted_tag_vectors = tag_weight * tag_vector_np

        weighted_avg_text_vector = np.array(weighted_text_vectors)
        weighted_avg_tag_vector = np.array(weighted_tag_vectors)

        weighted_avg_vector = weighted_avg_text_vector + weighted_avg_tag_vector

        return weighted_avg_vector

    except Exception as e:
        print(f"Error in weighted_vectorising function: {e}")
        # Re-raise the exception to propagate it further if needed
        raise


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


def vector_fetcher(pinecone_index, vector_id, vector_type):
    vector_response = pinecone_index.fetch([vector_id])
    vector = vector_response['vectors'][vector_id]['values']
    return vector


def story_user_vectors_fetcher(pinecone_index, story_id, user_id):
    story_response = pinecone_index.fetch([story_id])
    user_response = pinecone_index.fetch([user_id])
    user_vector = user_response['vectors'][user_id]['values']
    story_vector = story_response['vectors'][story_id]['values']
    return story_vector, user_vector


def single_vector_fetcher(pinecone_index, vector_id):
    response = pinecone_index.fetch([vector_id])
    vector = response['vectors'][vector_id]['values']
    return vector


def list_to_nparray(story_vector, user_vector):
    np_story_vector = np.array(story_vector)
    np_user_vector = np.array(user_vector)
    return np_story_vector, np_user_vector


# ------------------------ USER INTERACTION LIKE/UNLIKE --------------------------- #
def like_story_operations(np_user_vector, np_story_vector, user_weight):
    if user_weight == 1:
        updated_user_vector = np_story_vector
        return updated_user_vector
    else:
        updated_user_vector = ((np_user_vector * (user_weight - 1)) + np_story_vector) / user_weight
        return updated_user_vector


def unlike_story_operations(np_user_vector, np_story_vector, user_weight):
    if user_weight != 0:
        updated_user_vector = ((np_user_vector * (user_weight + 1)) - np_story_vector) / user_weight
    else:
        updated_user_vector = np.array(create_empty_float_list())
    return updated_user_vector


# ------------------------ RECOMMENDATION --------------------------- #
def recommendation_parser(data: Recommend):
    user_id = data.userId
    excluded_ids = data.excludedIds
    vector_type = data.vector_type
    return user_id, excluded_ids, vector_type


def story_and_user_recommender(pinecone_index, user_vector, excluded_ids, vector_type):
    response = pinecone_index.query(
        vector=user_vector,
        top_k=100,
        filter={"id": {"$nin": excluded_ids},
                "type": {"$eq": vector_type}
                },
    )
    print(response)
    ids = [match['id'] for match in response['matches']]
    scores = [match['score'] for match in response['matches']]
    return ids, scores

def create_empty_float_list():
    empty_list = [0.0] * 300
    return empty_list
