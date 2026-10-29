# To Do

Deadline: **2 November 2026**.

## Deliverables

| | Deliverable | Status |
|---|---|---|
| A | Source code (framework, config, test data, dependencies), emailed to the instructor | All tests written and passing on the live site |
| B | PowerPoint | Not started |
| C | Live demo | Not rehearsed |
| D | README | Done: still needs a clean-machine check |
| E | Test inventory (`docs/test-inventory.md`) | Done, including the upload tests |
| F | Individual contribution record | Not started |

### A. Source code

- [x] Write the 3 upload tests
- [x] Get them passing on the live site (see "Remaining UI tests" below)
- [ ] Email the project to the instructor (muhammad.fatani@ext.junia.com), without `.env`

### B. PowerPoint

- [ ] Title and team members
- [ ] The app and why we chose it
- [ ] Tool and language, and why (Robot Framework, Python)
- [ ] Architecture (page objects, API client, libraries, config)
- [ ] Design principles and naming conventions
- [ ] Test strategy
- [ ] UI coverage and results
- [ ] API coverage and results
- [ ] The data-driven test (UI-001)
- [ ] Test independence and parallel execution
- [ ] Challenges
- [ ] One failure investigation (suggested: FL-004, quantity of 0 accepted)
- [ ] Each member's specific contribution
- [ ] Lessons learned

### C. Live demo

- [ ] Launch the app
- [ ] Run the UI tests
- [ ] Run the API tests
- [ ] Show assertions in the code
- [ ] Show the data-driven test
- [ ] Show a parallel run
- [ ] Explain the failure investigation
- [ ] Show the reports
- [ ] Rehearse, including answering questions on any part of the code

### D. README

- [ ] Clean-machine check: someone else sets up and runs the project using only the README

### E. Test inventory and per-test documentation

- [ ] For every test, add preconditions, test data, steps, actual result and evidence (brief §4 and §5)

### F. Individual contribution record

- [ ] For each member: area, files or modules, and what they can explain

## Remaining UI tests

UI-008, UI-009 and UI-F01 are written (`tests/ui/event_uploads.robot`) and pass on the live site.

- [x] Add image upload and an optional PDF/Word "Event Details" upload to the event form
- [x] Set up the Cloudinary unsigned upload preset
- [x] Write UI-008 (image upload), UI-009 (document upload) and UI-F01 (unsupported file rejected)
- [x] Add sample files to `test-data/files/`
- [x] Add the tests to `docs/test-inventory.md`
- [x] In Vercel (frontend project), add `VITE_CLOUDINARY_CLOUD_NAME` and `VITE_CLOUDINARY_UPLOAD_PRESET`, then redeploy
- [x] Merge and deploy the backend branch `feat/event-file-uploads`, so the server stores the details document
- [x] Re-run the upload tests on the live site and close FL-006
- [x] Take the evidence screenshots for UI-008, UI-009 and UI-F01 from the live site
- [x] Run the full suite in parallel and update the "Last full run" line in `docs/test-inventory.md`
- [ ] Deploy `fix/image-picker` ("Choose image for the event"), then retake the UI-008 and UI-F01 screenshots
