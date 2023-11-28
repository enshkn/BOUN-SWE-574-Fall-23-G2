import pinecone
from classes import Text
from gensim.utils import simple_preprocess


def story_parser(data: Text):
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
