"""Builds test data that is unique per run and clearly marked as test data.

The event itself comes from test-data/sample_event.json, so the UI and API tests
use the same realistic event. Unique values let tests run in parallel against the
live site without clashing, and the [TEST] prefix makes any leftover record easy
to spot.
"""

import json
import uuid
from datetime import date, timedelta
from pathlib import Path

SAMPLE_EVENT_FILE = Path(__file__).parent.parent / "test-data" / "sample_event.json"


class TestDataFactory:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def sample_event(self):
        """The sample event exactly as written in test-data/sample_event.json."""
        return json.loads(SAMPLE_EVENT_FILE.read_text(encoding="utf-8"))

    def unique_event_title(self):
        return f"[TEST] {self.sample_event()['title']} {self._short_id()}"

    def unique_email(self):
        return f"test+{self._short_id()}@example.com"

    def unique_booking_reference(self):
        return f"TEST-{self._short_id().upper()}"

    def future_date(self, days_ahead=30):
        """Returns a date in the format date inputs expect: YYYY-MM-DD."""
        return (date.today() + timedelta(days=int(days_ahead))).isoformat()

    def past_date(self, days_ago=1):
        return (date.today() - timedelta(days=int(days_ago))).isoformat()

    def valid_event_payload(self):
        """A complete, valid body for POST /events, built from the sample event."""
        event = self.sample_event()
        return {
            "title": self.unique_event_title(),
            "date": self.future_date(),
            "time": event["time"],
            "location": event["location"],
            "desc": event["desc"],
            "leadImage": event["leadImage"],
            "tickets": event["tickets"],
        }

    def _short_id(self):
        return uuid.uuid4().hex[:8]
