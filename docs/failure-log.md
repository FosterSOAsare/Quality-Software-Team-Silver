# Failure Log

Every real failure met during development, how it was investigated and how it was fixed.
Rule: an expected result is only changed when it was wrong about the **intended** app behaviour.

---

## FL-001: Booking page heading did not match (UI-001.3)

| | |
|---|---|
| **Date** | 27 Oct 2026 |
| **Test** | UI-001.3 Book Link Opens Booking Page |
| **Detected by** | First full run of `tests/ui` |
| **Error** | `Text 'BOOK YOUR EXPERIENCE' (str) should be 'Book Your Experience' (str)` |
| **Root cause category** | Faulty assertion |

**Investigation.** The expected text was copied from the source code
(`<PageHero title="Book Your Experience" />`). The page hero applies CSS `uppercase`, and the
Browser library reads text the way it is rendered, so the user really sees `BOOK YOUR EXPERIENCE`.
The other five navigation rows passed because their titles are already uppercase in the source.

**Fix.** Expected heading changed to `BOOK YOUR EXPERIENCE`, which is what a guest sees.
Justified because the test checks the user-visible page, not the source string.

**Evidence.** `evidence/failures/FL-001-heading-expected-in-wrong-case.png`

**Prevention.** `Page Heading Should Be` now documents that it compares the on-screen text.
Expected UI text is taken from the rendered page, not from source code.

---

## FL-002: Validation messages never appeared for an invalid email (now UI-004)

| | |
|---|---|
| **Date** | 27 Oct 2026 |
| **Test** | Booking Rejects Invalid Guest Details (later merged into UI-004) |
| **Detected by** | First full run of `tests/ui` |
| **Error** | `Timeout 15000ms exceeded ... waiting for locator('text="First name must be at least 2 characters"') to be visible` |
| **Root cause category** | Faulty assertion (wrong assumption about which layer validates) |

**Investigation.** A separate test that submitted only a short first name showed the *same*
message without problems, so the message itself worked. The difference was the email `not-an-email`. In the source, the booking `<form>` has
no `noValidate` and the email field is `type="email"`. The browser's built-in check therefore blocks
the submit **before** the app's own validation runs, so none of the app's messages are rendered.
The app still rejects the bad email; it is just the browser doing it.

**Fix.** The test now uses `jane@example`. It passes the browser's check but fails the app's
stricter rule (no top-level domain), so the test reaches and verifies the app's own messages.
The expected messages were not changed; only the test data was, because the old data never
reached the layer under test.

**Evidence.** `evidence/failures/FL-002-browser-blocks-email-before-app.png` shows the browser's
own "Please include an '@'" popup.

**Prevention.** When a field has a native HTML type (`email`, `number`, `url`), tests choose data
deliberately for the layer they mean to test.

---

## FL-003: Every test failed instantly under pabot

| | |
|---|---|
| **Date** | 27 Oct 2026 |
| **Command** | `pabot --testlevelsplit --processes 4 --outputdir reports tests/ui` |
| **Error** | All 16 tests `FAILED` in ~0.2 s. Worker log: `'robot' is not recognized as an internal or external command` |
| **Root cause category** | Environment issue |

**Investigation.** The same tests had just passed with `robot`, and nothing ran long enough to
open a browser. `reports/pabot_results/0/robot_stderr.out` (the worker's error output) showed pabot starts each worker by
calling `robot` from the PATH, and the virtual environment was not activated.

**Fix.** Activate the virtual environment before running pabot. Result: every test passed in parallel.

**Evidence.** `evidence/failures/FL-003-pabot-worker-output.txt`

**Prevention.** The README tells you to activate the venv first, for every command.

---

## FL-004: Ticket quantity of 0 is not rejected on the form (UI-006)

| | |
|---|---|
| **Date** | 29 Oct 2026 |
| **Test** | UI-006 Ticket Quantity Limit Must Be At Least 1 |
| **Error** | `Timeout 15000ms exceeded ... waiting for locator('text="Quantity must be at least 1"')` |
| **Root cause category** | **Application defect** (fixed and deployed) |

**Investigation.** Every other field was filled with valid data, so quantity was the only invalid
value. The screenshot shows `0` in the field and no message under it. In the client source,
`event-schema.ts` has `totalQuantity: z.number().optional().nullable()` with no minimum, so the
browser accepts 0 and sends it. The server does reject it. Checked directly with the API:
`400` and a raw JSON message (`"Too small: expected number to be >=1"`), which the page shows in a
general "Submission Error" banner instead of under the field. Confirmed via `GET /api/events` that
no test event was created.

**Corrective action.** Added the missing minimum to the client schema, on branch
`fix/ticket-quantity-min` of the Amethyst client:
`totalQuantity: z.number().min(1, "Quantity must be at least 1").optional().nullable()`.
The expected result was not changed: it describes the intended behaviour, which the server
already enforces.

**Verification.** Type-check passed. The fixed client was run locally against the live backend
and UI-006 was run against it (`--variable BASE_URL:http://localhost:5173`): **PASS**.
`GET /api/events` afterwards showed no test event was created.

**Status.** Closed. Commit `bd8562a` was merged and deployed to Vercel on 29 Oct 2026.
UI-006 re-run against the live site: **PASS**, alone and in the full parallel run.

**Evidence.** Before the fix: `evidence/failures/FL-004-quantity-0-without-error.png` and
`evidence/failures/FL-004-log/log.html`. After: `evidence/screenshots/UI-006-quantity-0-rejected.png`.

**Prevention.** UI-006 stays in the suite as a regression test: if the minimum is ever removed,
it fails again.

---

## FL-005: Admin login "did not work" in the test

| | |
|---|---|
| **Date** | 29 Oct 2026 |
| **Test** | UI-006 (suite setup: `Start Admin Session`) |
| **Error** | `URL '.../admin/login' (str) should be '.../bookings' (str)` |
| **Root cause category** | Synchronization issue |

**Investigation.** The passcode was checked directly against `POST /api/auth/login`: 200 with a
token, so the passcode was right. The failure screenshot showed the login button still reading
`VERIFYING...`. The app adds an artificial 0.8 s delay before calling the server. `Get Url ==` only
retries its assertion for the Browser library's default of **1 second** (`retry_assertions_for`),
not the 15 s browser timeout, so it gave up while login was still in progress.

**Fix.** `Page Url Should End With` now uses `Wait For Condition    Url    ==    ...`, which waits
up to the browser timeout. No `Sleep` was added.

**Evidence.** `evidence/failures/FL-005-login-still-verifying.png`

**Prevention.** Any check that follows a server call waits with `Wait For Condition` or
`Wait For Elements State`. The keyword's documentation explains why.

---

## FL-006: Upload tests time out on the live site

| | |
|---|---|
| **Date** | 29 Oct 2026 |
| **Tests** | UI-008, UI-009, and UI-006 (which now uploads an image while filling the form) |
| **Error** | `TimeoutError: locator.waitFor: Timeout 15000ms exceeded` while waiting for the uploaded file's name |
| **Root cause category** | Environment issue (closed) |

**Investigation.** UI-F01 passed while every test that needs a real upload failed, which pointed away
from the tests. The failure screenshot shows the app's own message under the image field:
**"File uploads are not configured."** The app shows this when `VITE_CLOUDINARY_CLOUD_NAME` and
`VITE_CLOUDINARY_UPLOAD_PRESET` are missing. Vite builds these into the site at build time, so the
live build was made without them. To confirm the tests themselves are right, the same four tests were
run against a local build that has the two settings (`--variable BASE_URL:http://localhost:5173`):
**4 of 4 passed**.

**Evidence.** `evidence/failures/FL-006-uploads-not-configured-on-live-site.png`

**Corrective action.** Add both Cloudinary variables to the frontend project in Vercel and redeploy.
No test was changed: the expected behaviour (an uploaded image shows its name and preview) is right.

**Verification.** After the settings were added in Vercel and the site redeployed, the same four
tests were re-run against the live site: **4 of 4 passed**. The full suite then passed in parallel
(18 of 18).

**Prevention.** The README lists every setting the app needs. When the upload tests fail with a
timeout, the first thing to check is the message under the field, which names this exact cause.
