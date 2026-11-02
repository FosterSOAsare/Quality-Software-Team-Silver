# Individual Contribution Record

**Team Silver** · Robot Framework · UI & API Test Automation Challenge
Application under test: Amethyst Suites & Dining (https://amethyst-sd.vercel.app)
Repository: `https://github.com/FosterSOAsare/Quality-Software-Team-Silver`

> Sources: the repository's commit history and the team's Teams conversation (29 Oct – 1 Nov 2026).

***

## Summary

| Member | Main area | Deliverables / files |
| ------ | --------- | -------------------- |
| Foster Solomon Owusu ASARE | Application under test, automation framework, UI and API tests | Amethyst app, whole automation repository, README, test inventory, failure log |
| Kwasi ASARE-BOATENG | Live demonstration and test videos | Live demo recording, one recorded demonstration per test |
| Joshua Akwasi DONKOR | Presentation slides (with Jasmine) | `Team_Silver_Presentation.pptx` |
| Jasmine AMANKWAH | Presentation slides (with Joshua) | `Team_Silver_Presentation.pptx` |
| Chloé DEMANZE | Individual contribution record | `docs/contributions.md`, contribution slide |

***

## What each member can explain

Foster wrote the tests. So that every member can explain part of the code, the UI and API
tests were split between all five members. Each member can walk through their tests, the page
resources and keywords those tests use, and what each assertion checks.

| Member | UI tests | API tests | Files to know |
| ------ | -------- | --------- | ------------- |
| Foster Solomon Owusu ASARE | UI-008, UI-009, UI-010, UI-F01 (uploads) | API-001, API-002 (admin login) | `tests/ui/event_uploads.robot`, `tests/api/auth_api.robot`, `resources/pages/event_form_page.resource`, `resources/pages/admin_login_page.resource`, `resources/api/api_client.resource` |
| Kwasi ASARE-BOATENG | UI-002, UI-003, UI-004 (booking page) | API-003 (bookings need a token) | `tests/ui/booking.robot`, `tests/api/bookings_api.robot`, `resources/pages/booking_page.resource` |
| Joshua Akwasi DONKOR | UI-001 (data-driven navigation), UI-005 (contact message) | API-004 (unknown booking reference) | `tests/ui/navigation.robot`, `tests/ui/contact.robot`, `tests/api/bookings_api.robot`, `resources/pages/site_header.resource`, `resources/pages/contact_page.resource` |
| Jasmine AMANKWAH | UI-006 (ticket quantity) | API-006 (past event date) | `tests/ui/event_form.robot`, `tests/api/events_api.robot`, `resources/pages/event_form_page.resource`, `libraries/TestDataFactory.py` |
| Chloé DEMANZE | UI-007 (ticket dialog) | API-005 (event create, read, update, delete) | `tests/ui/event_details.robot`, `tests/api/events_api.robot`, `resources/pages/event_details_page.resource`, `libraries/SchemaValidator.py`, `test-data/schemas/event.json` |

Every member can also explain the shared structure: test files call keywords from
`resources/`, which hold the locators (UI) and HTTP calls (API); `resources/common.resource`
opens the browser and holds shared checks; `config/env.py` reads the settings from `.env`.
Foster can explain any part of the framework and the failure investigations in `docs/failure-log.md`.

***

## Details per member

### Foster Solomon Owusu ASARE

**Application under test**

* Provided and maintains the Amethyst Suites & Dining website (frontend and REST API).
* Added the image upload and the PDF/Word "Event Details" upload to the event form so the mandatory upload controls could be tested.
* Fixed and deployed the application defects found by the tests (see `docs/test-inventory.md`), e.g. ticket quantity 0 accepted (FL-004), 500 errors returned instead of 400/404, event IDs clashing under parallel creation.

**Automation framework and tests**

* Framework structure: `config/env.py`, `resources/common.resource`, `resources/pages/`, `resources/api/`, `libraries/`, `test-data/`.
* UI tests (`tests/ui/`): UI-001 to UI-010 and UI-F01, including the data-driven test (UI-001) and the upload tests (UI-008, UI-009, UI-F01).
* API tests (`tests/api/`): API-001 to API-006.
* Parallel execution with Pabot (full run: 19 of 19 passing, 29 Oct 2026).

**Documentation**

* `README.md`, `docs/test-inventory.md`, `docs/failure-log.md`, `todo.md`.
* Coordinated the team: task split, meetings and follow-up.

**Commits**: a943b6a, 08b0eb1, 5c515f8, b3791bc (29 Oct 2026).

***

### Kwasi ASARE-BOATENG

* Recorded the live demonstration of the automated test suite (shared 31 Oct 2026).
* Recorded a demonstration of each test, then split the recording into one video per test (shared 1 Nov 2026).
* Both recordings are sent to the instructor with the submission email; they are not stored in the repository.

***

### Joshua Akwasi DONKOR

* Built the team presentation with Jasmine (`Team_Silver_Presentation.pptx`).

***

### Jasmine AMANKWAH

* Built the team presentation with Joshua and shared the deck with the team (`Team_Silver_Presentation.pptx`, 31 Oct 2026).

***

### Chloé DEMANZE

* Wrote this individual contribution record (deliverable F): collected each member's contribution from the repository history and the team conversation, and followed up with members for missing details.
* Wrote the content of the "Individual contributions" slide.