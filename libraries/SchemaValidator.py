"""Checks API responses against the JSON schemas in test-data/schemas/."""

import json
from pathlib import Path

from jsonschema import ValidationError, validate

SCHEMA_FOLDER = Path(__file__).parent.parent / "test-data" / "schemas"


class SchemaValidator:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def response_should_match_schema(self, response_body, schema_name):
        """Fails with a readable message if the body does not match `<schema_name>.json`."""
        schema = json.loads((SCHEMA_FOLDER / f"{schema_name}.json").read_text())
        try:
            validate(instance=response_body, schema=schema)
        except ValidationError as error:
            location = "/".join(str(part) for part in error.absolute_path) or "(root)"
            raise AssertionError(
                f"Response does not match schema '{schema_name}' at {location}: {error.message}"
            ) from None
