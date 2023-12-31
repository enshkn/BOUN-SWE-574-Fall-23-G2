from cf import (list_to_string, generate_id_with_prefix, generate_ids_with_prefix, parse_id_with_prefix, parse_ids_with_prefix_for_lists,
                story_parser, text_processor, tokenizer, weighted_vectorising, user_like_unlike_parser, list_to_nparray, like_story_operations,
                unlike_story_operations, recommendation_parser, create_empty_float_list, token_counter)
from classes import Story, UserInteraction, Recommend
from tests_artifacts import mock_model, interaction_data, interaction_data_invalid
import numpy as np
import unittest


class TestListToString(unittest.TestCase):
    def test_empty_list(self):
        self.assertEqual(list_to_string([]), "")

    def test_string_elements(self):
        self.assertEqual(list_to_string(['hello', 'world']), "hello world")
        self.assertEqual(list_to_string(['testing', '123', '$%^']), "testing 123 $%^")

    def test_numeric_elements(self):
        self.assertEqual(list_to_string([1, 2, 3]), "1 2 3")
        self.assertEqual(list_to_string([4.5, 6.7, 8.9]), "4.5 6.7 8.9")
        self.assertEqual(list_to_string([10, 20.5, 30]), "10 20.5 30")

    def test_other_data_types(self):
        self.assertEqual(list_to_string([True, False]), "True False")
        self.assertEqual(list_to_string([None, 42]), "None 42")
        self.assertEqual(list_to_string([{'key': 'value'}, [1, 2, 3]]), "{'key': 'value'} [1, 2, 3]")

class TestGenerateIDWithPrefix(unittest.TestCase):
    def test_valid_inputs(self):
        self.assertEqual(generate_id_with_prefix("123", "user"), "u123")
        self.assertEqual(generate_id_with_prefix(456, "story"), "s456")
        self.assertEqual(generate_id_with_prefix("111", "user"), "u111")
        self.assertEqual(generate_id_with_prefix(789, "story"), "s789")

    def test_invalid_inputs(self):
        with self.assertRaises(ValueError):
            generate_id_with_prefix("xyz", "invalid_type")


class TestGenerateIDsWithPrefix(unittest.TestCase):
    def test_valid_inputs(self):
        self.assertEqual(generate_ids_with_prefix(["123", "456"], "user"), ["u123", "u456"])
        self.assertEqual(generate_ids_with_prefix([789, 1011], "story"), ["s789", "s1011"])
        self.assertEqual(generate_ids_with_prefix(["666", 123], "user"), ["u666", "u123"])

    def test_invalid_inputs(self):
        with self.assertRaises(ValueError):
            generate_ids_with_prefix(["xyz", "def"], "invalid_type")


class TestParseIDWithPrefix(unittest.TestCase):
    def test_valid_inputs(self):
        self.assertEqual(parse_id_with_prefix("u123"), "123")
        self.assertEqual(parse_id_with_prefix("s456"), "456")
        self.assertEqual(parse_id_with_prefix("u789"), "789")
        self.assertEqual(parse_id_with_prefix("s1011"), "1011")

    def test_invalid_inputs(self):
        with self.assertRaises(ValueError):
            parse_id_with_prefix("x123")

class TestParseIDsWithPrefixForLists(unittest.TestCase):
    def test_valid_inputs(self):
        self.assertEqual(parse_ids_with_prefix_for_lists(["u123", "s456"]), [123, 456])
        self.assertEqual(parse_ids_with_prefix_for_lists(["u789", "s1011"]), [789, 1011])

    def test_invalid_inputs(self):
        with self.assertRaises(ValueError):
            parse_ids_with_prefix_for_lists(["x123", "s456"])

        with self.assertRaises(ValueError):
            parse_ids_with_prefix_for_lists(["u255", "st1011"])

# story parser tests

class TestTextProcessor(unittest.TestCase):
    def test_valid_input(self):
        # Test with valid inputs
        input_text = "This is a sample text for testing."
        input_tags = "simple tag example"
        expected_text_tokens = ['this', 'is', 'sample', 'text', 'for', 'testing']
        expected_tag_tokens = ['simple', 'tag', 'example']

        text_tokens, tag_tokens = text_processor(input_text, input_tags)
        self.assertEqual(text_tokens, expected_text_tokens)
        self.assertEqual(tag_tokens, expected_tag_tokens)

    def test_empty_input(self):
        # Test with empty inputs
        input_text = ""
        input_tags = ""
        expected_text_tokens = []
        expected_tag_tokens = []

        text_tokens, tag_tokens = text_processor(input_text, input_tags)
        self.assertEqual(text_tokens, expected_text_tokens)
        self.assertEqual(tag_tokens, expected_tag_tokens)

    def test_invalid_input(self):
        # Test with None as input
        input_text = None
        input_tags = None

        with self.assertRaises(Exception):
            text_processor(input_text, input_tags)


class TestTokenizer(unittest.TestCase):

    def test_valid_tokens(self):
        # Test with valid tokens present in the mock model
        input_tokens = ["apple", "banana", "orange"]
        expected_vectors = [
            [0.3, 0.5, 0.8],
            [0.1, 0.9, 0.6],
            [0.6, 0.2, 0.4]
        ]

        result = tokenizer(input_tokens, mock_model)
        self.assertEqual(result, expected_vectors)

    def test_invalid_tokens(self):
        # Test with tokens not present in the mock model
        input_tokens = ["pear", "grape"]
        expected_result = {"vectorized_text": []}

        result = tokenizer(input_tokens, mock_model)
        self.assertEqual(result, expected_result)

    def test_empty_tokens(self):
        # Test with empty input tokens
        input_tokens = []
        expected_result = {"vectorized_text": []}

        result = tokenizer(input_tokens, mock_model)
        self.assertEqual(result, expected_result)


class TestWeightedVectorising(unittest.TestCase):
    def test_weighted_average(self):
        # Test with valid inputs to calculate the weighted average vector
        text_weight = 0.6
        tag_weight = 0.4
        text_vector = [
            np.random.rand(300),  # Example 300-dimensional vector
            np.random.rand(300),
            np.random.rand(300)
        ]
        tag_vector = [
            np.random.rand(300),  # Example 300-dimensional vector
            np.random.rand(300),
            np.random.rand(300)
        ]
        expected_result = text_weight * np.mean(text_vector, axis=0) + tag_weight * np.mean(tag_vector, axis=0)

        result = weighted_vectorising(text_weight, tag_weight, text_vector, tag_vector)
        np.testing.assert_allclose(result, expected_result, rtol=1e-4)  # Checking for approximate equality

    def test_invalid_input(self):
        # Test with invalid inputs (e.g., empty vectors)
        text_weight = 0.6
        tag_weight = 0.4
        text_vector = ["aaa"]
        tag_vector = ["vvv"]

        with self.assertRaises(Exception):
            weighted_vectorising(text_weight, tag_weight, text_vector, tag_vector)


class TestListToNpArray(unittest.TestCase):
    def test_convert_to_nparray(self):
        # Test with valid lists to convert to NumPy arrays
        story_vector = [0.1, 0.2, 0.3, 0.4]
        user_vector = [0.5, 0.6, 0.7, 0.8]

        expected_story_array = np.array(story_vector)
        expected_user_array = np.array(user_vector)

        result_story_array, result_user_array = list_to_nparray(story_vector, user_vector)

        self.assertTrue(np.array_equal(result_story_array, expected_story_array))
        self.assertTrue(np.array_equal(result_user_array, expected_user_array))

    def test_empty_list(self):
        # Test with empty lists
        story_vector = []
        user_vector = []

        expected_story_array = np.array([])
        expected_user_array = np.array([])

        result_story_array, result_user_array = list_to_nparray(story_vector, user_vector)

        self.assertTrue(np.array_equal(result_story_array, expected_story_array))
        self.assertTrue(np.array_equal(result_user_array, expected_user_array))


class TestLikeStoryOperations(unittest.TestCase):
    def test_like_weight_1(self):
        # Test with user_weight equal to 1 (story vector becomes the updated user vector)
        np_user_vector = np.array([0.2, 0.4, 0.6])
        np_story_vector = np.array([0.1, 0.3, 0.5])
        user_weight = 1

        expected_updated_user_vector = np_story_vector

        result = like_story_operations(np_user_vector, np_story_vector, user_weight)
        np.testing.assert_array_equal(result, expected_updated_user_vector)

    def test_like_weight_greater_than_1(self):
        # Test with user_weight greater than 1 (calculate updated user vector)
        np_user_vector = np.array([0.2, 0.4, 0.6])
        np_story_vector = np.array([0.1, 0.3, 0.5])
        user_weight = 2

        expected_updated_user_vector = ((np_user_vector * (user_weight - 1)) + np_story_vector) / user_weight

        result = like_story_operations(np_user_vector, np_story_vector, user_weight)
        np.testing.assert_allclose(result, expected_updated_user_vector, rtol=1e-4)

    def test_like_weight_0(self):
        # Test with user_weight equal to None (should raise an exception)
        np_user_vector = np.array([0.2, 0.4, 0.6])
        np_story_vector = np.array([0.1, 0.3, 0.5])
        user_weight = None

        with self.assertRaises(Exception):
            like_story_operations(np_user_vector, np_story_vector, user_weight)

class TestUnlikeStoryOperations(unittest.TestCase):
    def test_unlike_weight_not_equal_to_0(self):
        # Test with user_weight not equal to 0 (calculate updated user vector)
        np_user_vector = np.array([0.2, 0.4, 0.6])
        np_story_vector = np.array([0.1, 0.3, 0.5])
        user_weight = 2

        expected_updated_user_vector = ((np_user_vector * (user_weight + 1)) - np_story_vector) / user_weight

        result = unlike_story_operations(np_user_vector, np_story_vector, user_weight)
        np.testing.assert_allclose(result, expected_updated_user_vector, rtol=1e-4)

class TestRecommendationParser(unittest.TestCase):
    def test_extract_info(self):
        # Test with valid Recommend data
        user_id = "u123"
        excluded_ids = ["1", "2", "3"]
        vector_type = "story"

        recommendation_data = Recommend(userId=user_id, excludedIds=excluded_ids, vector_type=vector_type)

        expected_result = (user_id, excluded_ids, vector_type)
        result = recommendation_parser(recommendation_data)
        self.assertEqual(result, expected_result)

    def test_extract_info_with_int_ids(self):
        # Test with valid Recommend data
        user_id = "u123"
        excluded_ids = [1, 2, 3]
        vector_type = "story"

        recommendation_data = Recommend(userId=user_id, excludedIds=excluded_ids, vector_type=vector_type)

        expected_result = (user_id, excluded_ids, vector_type)
        result = recommendation_parser(recommendation_data)
        self.assertEqual(result, expected_result)


class TestCreateEmptyFloatList(unittest.TestCase):
    def test_empty_list_creation(self):
        # Test whether the function generates a list of 300 zeros
        result = create_empty_float_list()
        self.assertEqual(len(result), 300)
        self.assertTrue(all(isinstance(num, float) and num == 0.0 for num in result))


class TestTokenCounter(unittest.TestCase):
    def test_valid_input(self):
        # Test with valid input (both text_vectors and tag_vectors are lists)
        text_vectors = [1, 2, 3]
        tag_vectors = ['a', 'b']

        result = token_counter(text_vectors, tag_vectors)
        self.assertEqual(result, len(text_vectors) + len(tag_vectors))

    def test_invalid_input_text_vectors(self):
        # Test with invalid input (text_vectors is not a list)
        text_vectors = 5
        tag_vectors = ['a', 'b']

        result = token_counter(text_vectors, tag_vectors)
        self.assertEqual(result, 0)  # Expected result due to TypeError

    def test_invalid_input_tag_vectors(self):
        # Test with invalid input (tag_vectors is not a list)
        text_vectors = 7
        tag_vectors = 8

        result = token_counter(text_vectors, tag_vectors)
        self.assertEqual(result, 0)  # Expected result due to TypeError

# ------------------------------- TESTED WITH POSTMAN ------------------------------- #

# upsert

# update_user_vector done

# user_like_unlike_parser done

# vector_fetcher done

# single_vector_fetcher

# user_recommender

# story_recommender

# upsert for empty lists - not using

# update_story_vector - not using

# story_user_vectors_fetcher - not using


if __name__ == '__main__':
    unittest.main()
