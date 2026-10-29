# Test Inventory

Last full run: 29 Oct 2026, against https://amethyst-sd.vercel.app, in parallel
(`pabot --processes 4`): **19 of 19 report entries pass.**

## Target (from the assignment)

| Requirement | Target | Current |
|---|---|---|
| Passing UI tests | 8–10 | 10 |
| Failure-oriented UI test | 1 | 1 (UI-F01) |
| Data-driven UI test | At least 1 | 1 (UI-001, 3 data rows) |
| Passing API tests | 4–8 | 6 |
| Genuine failure investigation | 1 | 6 logged in `failure-log.md` |

UI-001 is one test case run over 3 data rows. The Robot report lists each row separately,
so the report shows 19 entries for these 17 test cases.

## UI tests

| ID | Name | Type | Expected result | Status |
|---|---|---|---|---|
| UI-001 | Header Link Should Open Page (3 rows: Rooms, Contact, Book) | Navigation, data-driven | Correct URL, correct page heading, link marked active | Pass |
| UI-002 | Room Type Dropdown Updates Room Numbers | Dropdown, positive | `THE DELUXE ROOM` selected and room number becomes `Room 201` | Pass |
| UI-003 | Calendar Disables Past Dates | Date validation, negative | Every day before today is disabled | Pass |
| UI-004 | Guest Details Can Be Edited Cleared And Validated | Text input, field validation, negative | Field holds `Jane`, then `Janet`, then is empty; invalid details show three exact messages | Pass |
| UI-005 | Message Text Area Enforces Minimum Length And Keeps Multi-Line Text | Text area, boundary, negative | 9 characters rejected, 10 accepted, three-line message kept exactly | Pass |
| UI-006 | Ticket Quantity Limit Must Be At Least 1 | Number input, boundary, dynamic element, negative | Field appears on "Add Quantity Limit"; 0 shows `Quantity must be at least 1`; 1 clears it; field disappears on "Make Unlimited" | Pass (failed first on app defect FL-004, fixed; later on FL-006, fixed) |
| UI-007 | Ticket Dialog Shows Event Tickets And Closes | Dialog, state verification, dynamic element | Event created via API shows its title; dialog opens listing `General Admission` at `GHS150`; total goes `GHS150` → `GHS300`; dialog closes | Pass |
| UI-008 | Event Image Upload Shows Preview And File Name | Image upload, positive | With the fields above it filled in, `jazz-night.jpg` uploads; its name is shown and its preview is loaded from `res.cloudinary.com` | Pass |
| UI-009 | Event Details Document Upload Shows File Name And Can Be Removed | File upload, dynamic element, positive | `jazz-night-programme.pdf` uploads and its name is shown; after "Remove" the name disappears | Pass |
| UI-010 | Event Details Rejects A File In The Wrong Format | File validation, negative | Choosing the photo `jazz-night.jpg` as the details document shows exactly `Please choose a PDF or Word document`; nothing is uploaded | Pass |
| UI-F01 | Event Image Rejects A File That Is Not An Image | Failure-oriented, file validation, negative | `not-an-image.txt` shows exactly `Please choose a JPG, PNG or WEBP image`; nothing is uploaded | Pass |

## API tests

| ID | Name | Method + endpoint | Expected | Assertions | Status |
|---|---|---|---|---|---|
| API-001 | Admin Login With Correct Passcode Returns A Token | `POST /auth/login` | 200 | Body matches `login_response` schema; `Content-Type` is JSON | Pass |
| API-002 | Admin Login With Wrong Passcode Is Rejected | `POST /auth/login` | 401 | Message `Invalid passcode`; no `token` in body | Pass |
| API-003 | Bookings List Requires An Admin Token | `GET /bookings` | 401 | Message `Missing or invalid token` | Pass |
| API-004 | Unknown Booking Reference Returns Not Found | `GET /bookings/:reference` | 404 | Message `Booking not found` | Pass |
| API-005 | Event Can Be Created Read Updated And Deleted | `POST`, `GET`, `PUT`, `DELETE /events` | 201, 200, 200, 204, then 404 | Body matches `event` schema; title and ticket saved; update applied; deleted event returns `Event not found` | Pass |
| API-006 | Event With A Past Date Is Rejected | `POST /events` | 400 | Message is exactly `Event date cannot be in the past` | Pass |

Admin auth comes from `ADMIN_PASSCODE` in `.env`. The token and passcode never appear in
`log.html` or `output.xml` (checked after every run during development).

Sample upload files are in `test-data/files/`. The sample event used by the UI and API tests is `test-data/sample_event.json`.

## Mandatory control coverage

| Control | Covered by | Status |
|---|---|---|
| Text input | UI-004 | Done |
| Number input | UI-006 | Done |
| Text area | UI-005 | Done |
| File upload | UI-009, UI-010 | Done |
| Image upload | UI-008, UI-F01 | Done |
| Dropdown | UI-002 | Done |
| Date picker | UI-003 | Done |
| Dialog | UI-007 | Done |
| Dynamic elements | UI-006, UI-007, UI-009 | Done |

## Coverage types

| Type | Covered by |
|---|---|
| Positive | UI-001, UI-002, UI-007, UI-008, UI-009, API-001, API-005 |
| Negative | UI-003, UI-004, UI-005, UI-006, UI-010, UI-F01, API-002, API-003, API-004, API-006 |
| Boundary | UI-005, UI-006, API-006 |
| Field / data validation | UI-004, API-006 |
| Date validation | UI-003, API-006 |
| Dynamic element | UI-006, UI-007, UI-009 |
| Dialog handling | UI-007 |
| State verification | UI-007 (API-created event shown in the UI) |
| Data-driven | UI-001 |
| Schema / contract | API-001, API-005 |
| Auth / authorization | API-001, API-002, API-003 |
| CRUD | API-005 |
| Headers | API-001 |
| File validation | UI-010 (document field), UI-F01 (image field) |

## App gaps found while testing

Fixed and deployed:

- Ticket quantity 0 was accepted by the event form (FL-004). Frontend.
- The ticket dialog had no dialog role and its icon buttons had no labels. Frontend.
- `POST /api/bookings` returned 500 for invalid data. Now 400 with readable messages; a double
  booking returns 409. Backend.
- Server validation errors were shown to users as raw JSON. `"message"` is now readable text,
  with the details in `"errors"`. Backend.
- The event form allowed today but the server rejected it. The server now accepts today. Backend.
- `PUT /api/events/:id` did not validate its body. It now uses the same rules as create. Backend.
- Deleting a missing event returned 500. Now 404. Backend.
- New event ids were made by reading the last id and adding 1, so parallel creates could clash.
  Now an atomic counter. Checked on the live API: 6 events created at the same moment got 6
  different ids. Backend.

Still open:

- The event page shows the raw stored date (`2026-11-28T00:00:00.000Z`) instead of a readable one
  (see `evidence/screenshots/UI-007-ticket-dialog-open.png`).
- The booking form's "6+" guest button sends `Number("6+")`, which is `NaN`, so every 6+ booking
  is rejected (400 "Guests must be at least 1").
- The booking calendar sets a `checkIn` / `checkOut` error but never displays its message. Only the
  border colour changes, so "Please select a check-in date" cannot be asserted as text.
- No element has a `data-testid` yet. Locators use form `name` attributes, placeholders, roles and
  visible text. All of them live in `resources/pages/`, so switching to test ids changes only those files.
