# To Do

Remaining UI tests. All three depend on file upload, which the app does not have yet.
We have 7 passing UI tests and need at least 8, so at least one of these is required.

## UI-008 Image upload

- [ ] Add image upload to the event form in the app (upload straight to Cloudinary, then save the image URL)
- [ ] Get the Cloudinary cloud name and an unsigned upload preset (allowed formats `jpg, png, webp`, max 5 MB)
- [ ] Write the test: upload a valid JPG and check its file name is shown
- [ ] Add the test to `docs/test-inventory.md`

## UI-F01 Unsupported file is rejected (the required failure-oriented test)

- [ ] Uses the same image upload as UI-008
- [ ] Write the test: upload a file that is not an image (e.g. `.txt`) and check the exact error message
- [ ] Add the test to `docs/test-inventory.md`

## UI-009 File upload (PDF)

- [ ] Decide where it goes (event form "event brief", or the contact page)
- [ ] Add PDF upload to the app: check type and size, show an error for bad files, show the file's name
- [ ] Write the test: upload a valid PDF and check its file name is shown
- [ ] Add the test to `docs/test-inventory.md`

## For all three

- [ ] Add sample files to `test-data/files/` (valid JPG, valid PDF, an unsupported file)
- [ ] Add a `Capture Evidence` step at each test's key check
- [ ] Run the full suite in parallel and update the "Last full run" line in `docs/test-inventory.md`
