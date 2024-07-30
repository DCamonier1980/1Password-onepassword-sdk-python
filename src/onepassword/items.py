# AUTO-GENERATED
from .core import _invoke
from json import loads
from .types import Item


class Items:
    """
    The Items API holds all operations the SDK client can perform on 1Password items.
    """

    def __init__(self, client_id):
        self.client_id = client_id

    async def create(self, params):
        """
        Create a new item
        """
        response = await _invoke(
            {
                "clientId": self.client_id,
                "invocation": {
                    "name": "Create",
                    "parameters": {
                        "params": params.dict(),
                    },
                },
            }
        )
        return Item(**loads(response))

    async def get(self, vault_id, item_id):
        """
        Get an item by vault and item ID
        """
        response = await _invoke(
            {
                "clientId": self.client_id,
                "invocation": {
                    "name": "Get",
                    "parameters": {
                        "item_id": item_id,
                        "vault_id": vault_id,
                    },
                },
            }
        )
        return Item(**loads(response))

    async def put(self, item):
        """
        Update an existing item.
        """
        response = await _invoke(
            {
                "clientId": self.client_id,
                "invocation": {
                    "name": "Put",
                    "parameters": {
                        "item": item.dict(),
                    },
                },
            }
        )
        return Item(**loads(response))

    async def delete(self, vault_id, item_id):
        """
        Delete an item.
        """

        await _invoke(
            {
                "clientId": self.client_id,
                "invocation": {
                    "name": "Delete",
                    "parameters": {
                        "vault_id": vault_id,
                        "item_id": item_id,
                    },
                },
            }
        )
