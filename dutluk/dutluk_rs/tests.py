from cf import list_to_string, generate_id_with_prefix
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
        self.assertEqual(generate_id_with_prefix("abc", "user"), "uabc")
        self.assertEqual(generate_id_with_prefix(789, "story"), "s789")

    def test_invalid_inputs(self):
        with self.assertRaises(ValueError):
            generate_id_with_prefix("xyz", "invalid_type")

        with self.assertRaises(ValueError):
            generate_id_with_prefix(None, "user")

        with self.assertRaises(ValueError):
            generate_id_with_prefix("", "story")

if __name__ == '__main__':
    unittest.main()
