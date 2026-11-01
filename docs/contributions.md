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