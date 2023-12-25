from cf import (list_to_string, generate_id_with_prefix, generate_ids_with_prefix, parse_id_with_prefix, parse_ids_with_prefix_for_lists,
                story_parser, text_processor, tokenizer)
from classes import Story
from tests_artifacts import mock_model
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




if __name__ == '__main__':
    unittest.main()
