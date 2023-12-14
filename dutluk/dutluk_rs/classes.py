from pydantic import BaseModel
from gensim.utils import simple_preprocess


class Story(BaseModel):
    text: str
    ids: str
    tags: list
    type: str

    def story_parser(self):
        """
        Parses story attributes and returns them as a tuple containing text, ids, tags, and type.

        Returns:
        - tuple: A tuple containing vector_text, vector_ids, vector_tags, and vector_type.

        This method is assumed to be part of a class, where it retrieves specific attributes:
        - self.text: The text attribute of the story.
        - self.ids: The ids attribute of the story.
        - self.tags: The tags attribute of the story.
        - self.type: The type attribute of the story.

        Note: The method assumes these attributes exist within the class instance.
        """

        try:
            vector_text = self.text
            vector_ids = self.ids
            vector_tags = self.tags
            vector_type = self.type

            # Print retrieved attributes for verification
            print(vector_text, vector_ids, vector_tags, vector_type)

            return vector_text, vector_ids, vector_tags, vector_type

        except Exception as e:
            print(f"Error occurred: {e}")
            # Re-raise the exception to propagate it further if needed
            raise

    def list_to_string(parameters_list: list):
        """
        Converts a list of parameters into a string by joining its elements with spaces.

        Parameters:
        - parameters_list (list): A list containing elements to be joined into a string.

        Returns:
        - str: A string created by joining the elements of the input list with spaces.

        This function takes a list and converts it into a string by joining its elements with spaces.
        """

        try:
            combined_string = ' '.join(map(str, parameters_list))
            return combined_string

        except Exception as e:
            print(f"Error in list_to_string function: {e}")
            # Re-raise the exception to propagate it further if needed
            raise


class UserInteraction(BaseModel):
    type: str
    storyId: str
    userId: str
    userWeight: int


class Recommend(BaseModel):
    userId: str
    excludedIds: list
    vector_type: str


class DeleteStory(BaseModel):
    storyId: str


class IdGenerator(BaseModel):
    def generate_id_with_prefix(vector_id, vector_type):
        """
        Generates an ID string with a specific prefix based on the provided parameters.

        Parameters:
        - vector_id (str or int): The ID value to be combined with the prefix.
        - vector_type (str): Indicates the type of vector. It should be 'user' or 'story'.

        Returns:
        - str: The generated ID string that combines the prefix and vector_id.

        Raises:
        - ValueError: If an invalid vector_type value is provided.
        """

        try:
            if vector_type == "user":
                prefix = "u"
            elif vector_type == "story":
                prefix = "s"
            else:
                raise ValueError("Invalid vector_type value. Only 'user' or 'story' is accepted.")

            result_id = f"{prefix}{vector_id}"
            print(result_id)
            return result_id

        except ValueError as ve:
            print(f"Error: {ve}")
            # Re-raise the exception to propagate it further if needed
            raise