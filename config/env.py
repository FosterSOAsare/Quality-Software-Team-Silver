"""Test configuration.

Every value comes from an environment variable, so the same tests can run
against any deployment. Values in a local `.env` file are loaded first.
The defaults point at the live Amethyst site.
"""

import os
from pathlib import Path

from dotenv import load_dotenv


PROJECT_ROOT = Path(__file__).parent.parent


def get_variables():
    load_dotenv(PROJECT_ROOT / ".env")

    return {
        "BASE_URL": os.getenv("BASE_URL", "https://amethyst-sd.vercel.app"),
        "API_BASE_URL": os.getenv("API_BASE_URL", "https://amethyst-backend.vercel.app/api"),
        "BROWSER": os.getenv("BROWSER", "chromium"),
        "HEADLESS": os.getenv("HEADLESS", "true").lower() == "true",
        # Generous on purpose: the backend is serverless and the first
        # request after a quiet period can be slow (cold start).
        "TIMEOUT": os.getenv("TIMEOUT", "15s"),
        # Seconds to wait for an API response (plain number, as the requests library expects).
        "API_TIMEOUT": float(os.getenv("API_TIMEOUT", "30")),
        # No default: admin tests stop with a clear message if it is missing.
        "ADMIN_PASSCODE": os.getenv("ADMIN_PASSCODE", ""),
        # Off by default. Turn on to save a screenshot at each test's key check.
        "CAPTURE_EVIDENCE": os.getenv("CAPTURE_EVIDENCE", "false").lower() == "true",
        "EVIDENCE_DIR": str(PROJECT_ROOT / "evidence" / "screenshots"),
    }
