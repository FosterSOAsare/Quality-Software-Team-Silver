# Amethyst Test Automation

Automated UI and API tests for [Amethyst Suites & Dining](https://amethyst-sd.vercel.app),
written with Robot Framework.

## Setup

Needs Python 3.11+ and Node.js 18+.

```bash
python -m venv .venv
.venv\Scripts\activate          # Windows
source .venv/bin/activate       # macOS / Linux

pip install -r requirements.txt
rfbrowser init chromium
```

Activate the virtual environment before running **any** command below.

## Configuration

All settings are optional. By default the tests run against the live site.
To change them, copy `.env.example` to `.env` and edit it:

| Variable | Default | Meaning |
|---|---|---|
| `BASE_URL` | `https://amethyst-sd.vercel.app` | Frontend under test |
| `API_BASE_URL` | `https://amethyst-backend.vercel.app/api` | Backend under test |
| `BROWSER` | `chromium` | `chromium`, `firefox` or `webkit` |
| `HEADLESS` | `true` | Set `false` to watch the browser |
| `TIMEOUT` | `15s` | How long to wait for elements |
| `ADMIN_PASSCODE` | none | Needed for admin tests (event form). Ask the team; never commit it |
| `CAPTURE_EVIDENCE` | `false` | Set `true` to save a screenshot at each UI test's key check into `evidence/screenshots/` |

To watch a single run without editing `.env`: `robot --variable HEADLESS:false --outputdir reports tests/ui`

## Running tests

```bash
# everything
robot --outputdir reports tests/

# UI only / API only
robot --outputdir reports tests/ui
robot --outputdir reports tests/api

# by tag, e.g. smoke tests
robot --include smoke --outputdir reports tests/

# in parallel, one test per process
pabot --testlevelsplit --processes 4 --outputdir reports tests/
```

## Reports

Each run writes to `reports/`:

- `report.html`: summary of passes and failures
- `log.html`: every step, with a screenshot on failure
- `output.xml`: raw results

## Project layout

```
config/env.py             Settings, read from environment variables
resources/common.resource Browser setup and shared keywords
resources/pages/          One file per page: its locators and actions
resources/api/            API client: every HTTP call goes through here
libraries/                Python keyword libraries (unique test data, schema checks)
test-data/schemas/        JSON schemas the API responses must match
tests/ui/                 UI test suites
tests/api/                API test suites
docs/test-inventory.md    Every test, its purpose and status
docs/failure-log.md       Real failures and how they were investigated
evidence/                 Screenshots and reports for the presentation (see evidence/README.md)
```

Test files contain no locators and no raw HTTP calls. If the website changes, only
`resources/pages/` should need editing; if the API changes, only `resources/api/`.

Every record a test creates is marked `[TEST]` and deleted in the test's teardown.
The admin token and passcode are kept out of `log.html` and `output.xml`.
