from cf import list_to_string, generate_id_with_prefix, generate_ids_with_prefix, parse_id_with_prefix, parse_ids_with_prefix_for_lists
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

class TestGenerateIDsWithPrefix(unittest.TestCase):
    def test_valid_inputs(self):
        self.assertEqual(generate_ids_with_prefix(["123", "456"], "user"), ["u123", "u456"])
        self.assertEqual(generate_ids_with_prefix([789, 1011], "story"), ["s789", "s1011"])
        self.assertEqual(generate_ids_with_prefix([], "user"), [])
        self.assertEqual(generate_ids_with_prefix(["abc", 123], "user"), ["uabc", "u123"])

    def test_invalid_inputs(self):
        with self.assertRaises(ValueError):
            generate_ids_with_prefix(["xyz", "def"], "invalid_type")

        with self.assertRaises(ValueError):
            generate_ids_with_prefix(None, "story")

class TestParseIDWithPrefix(unittest.TestCase):
    def test_valid_inputs(self):
        self.assertEqual(parse_id_with_prefix("u123"), "123")
        self.assertEqual(parse_id_with_prefix("s456"), "456")
        self.assertEqual(parse_id_with_prefix("u789"), "789")
        self.assertEqual(parse_id_with_prefix("s1011"), "1011")

    def test_invalid_inputs(self):
        with self.assertRaises(ValueError):
            parse_id_with_prefix("x123")

        with self.assertRaises(ValueError):
            parse_id_with_prefix(None)

if __name__ == '__main__':
    unittest.main()
