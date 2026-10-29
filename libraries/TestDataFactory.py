"""Builds test data that is unique per run and clearly marked as test data.

Unique values let tests run in parallel against the live site without
clashing, and the [TEST] prefix makes any leftover record easy to spot.
"""

import uuid
from datetime import date, timedelta


class TestDataFactory:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def unique_event_title(self):
        return f"[TEST] Event {self._short_id()}"

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
        """A complete, valid body for POST /events, with one unlimited ticket."""
        return {
            "title": self.unique_event_title(),
            "date": self.future_date(),
            "time": "19:00",
            "location": "Rooftop Lounge",
            "desc": "Automated test event. Safe to delete.",
            "leadImage": "https://images.unsplash.com/photo-1511192336575-5a79af67a629?q=80&w=1200&auto=format&fit=crop",
            "tickets": [{"type": "General Admission", "price": 50, "totalQuantity": None}],
        }

    def _short_id(self):
        return uuid.uuid4().hex[:8]
