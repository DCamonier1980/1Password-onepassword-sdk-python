# AUTO-GENERATED
from .client import Client
from .defaults import DEFAULT_INTEGRATION_NAME, DEFAULT_INTEGRATION_VERSION
from .types import *  # noqa F403
from .secrets import Secrets
from .items import Items
from .vaults import Vaults

import sys
import inspect
import typing

__all__ = [
    "Client",
    "Secrets",
    "Items",
    "Vaults",
    "DEFAULT_INTEGRATION_NAME",
    "DEFAULT_INTEGRATION_VERSION",
]

for name, obj in inspect.getmembers(sys.modules["onepassword.types"]):
    # Add all classes and instances of typing.Literal defined in types.py.
    if (
        inspect.isclass(obj)
        and inspect.getmodule(obj) == sys.modules["onepassword.types"]
    ) or type(eval(name)) == typing._LiteralGenericAlias:
        __all__.append(name)
