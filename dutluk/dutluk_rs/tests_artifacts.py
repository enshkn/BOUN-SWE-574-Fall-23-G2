mock_model = {
    "apple": [0.3, 0.5, 0.8],
    "banana": [0.1, 0.9, 0.6],
    "orange": [0.6, 0.2, 0.4]
}

interaction_data = {
    "type": "like",
    "storyId": "s123",
    "userId": "u456",
    "userWeight": 75
}

interaction_data_invalid = {
            "type": "like",
            "storyId": None,
            "userId": "user_789",
            "userWeight": 50
}