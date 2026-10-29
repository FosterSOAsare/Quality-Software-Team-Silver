# Evidence

Screenshots show the browser page only. All tests ran against https://amethyst-sd.vercel.app.

## Test reports

The reports of the latest run are in `reports/` at the project root, not here:
`report.html` (summary) and `log.html` (every step). Every run replaces them.
Open them in a web browser.

## `screenshots/`: proof of each UI test's key check

Taken at the moment the test's main assertion passed. They are recreated on every UI run
while `CAPTURE_EVIDENCE=true` is set in `.env` (or with `--variable CAPTURE_EVIDENCE:true`).

| File | Test | What it shows |
|---|---|---|
| `UI-001-ROOMS-link.png`, `UI-001-CONTACT-link.png`, `UI-001-BOOK-link.png` | UI-001 | Each header link opened the right page, and the link is marked active |
| `UI-002-room-type-options.png` | UI-002 | The room type dropdown's six options, with `THE STANDARD ROOM` selected. A real open dropdown list is drawn by the browser outside the page, so for this screenshot the dropdown was expanded into a list showing the same options |
| `UI-002-room-type-after.png` | UI-002 | After choosing: `THE DELUXE ROOM`, and the room number changed to `Room 201` |
| `UI-003-past-days-disabled.png` | UI-003 | Every day before today greyed out and unclickable |
| `UI-004-guest-details-validation.png` | UI-004 | The three exact validation messages for name, surname and email |
| `UI-005-message-9-characters-rejected.png` | UI-005 | `Message must be at least 10 characters` for a 9-character message; every other field valid, so it is the only error |
| `UI-005-message-multi-line-accepted.png` | UI-005 | A three-line message kept in the text area |
| `UI-006-quantity-0-rejected.png` | UI-006 | `Quantity must be at least 1` under a quantity of 0 |
| `UI-007-ticket-dialog-open.png` | UI-007 | The ticket dialog for an event created through the API, total at `GHS100` after `+` |

## `failures/`: the failures in `docs/failure-log.md`

These were recreated by running the original mistake again (the old expected value, the old
wait, or the app before its fix), because the first screenshots were deleted during a clean-up.
Each one failed with the same error as the original.

| File | Failure | Error |
|---|---|---|
| `FL-001-heading-expected-in-wrong-case.png` | FL-001 Faulty assertion | `Text 'BOOK YOUR EXPERIENCE' (str) should be 'Book Your Experience' (str)` |
| `FL-002-browser-blocks-email-before-app.png` | FL-002 Faulty assertion | Timed out waiting for the app's message. The screenshot shows why: the browser's own "Please include an '@'" popup blocked the submit |
| `FL-003-pabot-worker-output.txt` | FL-003 Environment issue | `'robot' is not recognized as an internal or external command` |
| `FL-004-quantity-0-without-error.png` | FL-004 Application defect | Timed out waiting for `Quantity must be at least 1`: the app before its fix showed no message |
| `FL-004-log/log.html` | FL-004 | The full Robot log of that failed run, with its screenshot |
| `FL-005-login-still-verifying.png` | FL-005 Synchronization issue | `URL '.../admin/login' (str) should be '.../bookings' (str)`, taken while the button still read `VERIFYING...` |

The fix for each failure is described in `docs/failure-log.md`. For FL-004, compare
`failures/FL-004-quantity-0-without-error.png` (before the fix) with
`screenshots/UI-006-quantity-0-rejected.png` (after).
