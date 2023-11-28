from pydantic import BaseModel


class Story(BaseModel):
    text: str
    ids: str
    tags: str
    type: str


class UserInteraction(BaseModel):
    type: str
    storyId: str
    userId: str
    userWeight: int
