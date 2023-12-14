from pydantic import BaseModel


class Story(BaseModel):
    text: str
    ids: str
    tags: list
    type: str


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