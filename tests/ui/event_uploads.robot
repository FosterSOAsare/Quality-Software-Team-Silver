*** Settings ***
Documentation       Admin event form: the event image upload and the event details document.
...                 Each test starts with the fields above the image filled in, like a real
...                 admin would. Files are uploaded to Cloudinary, but no event is saved, so
...                 nothing is created on the live site. Sample files live in test-data/files/.
Resource            ../../resources/common.resource
Resource            ../../resources/pages/event_form_page.resource

Suite Setup         Start Admin Session
Suite Teardown      End Admin Session
Test Setup          Open Event Form With Details Above The Image
Test Tags           ui    events    admin    upload


*** Test Cases ***
UI-008 Event Image Upload Shows Preview And File Name
    [Documentation]    Image upload: a valid JPG photo is uploaded, then shown with its name
    ...                and a preview loaded from Cloudinary.
    [Tags]    image-upload    positive
    Upload Event Image    jazz-night.jpg
    Uploaded Event Image Should Be    jazz-night.jpg
    Capture Evidence    UI-008-event-image-uploaded

UI-009 Event Details Document Upload Shows File Name And Can Be Removed
    [Documentation]    File upload: a PDF is uploaded and its name shown. Removing it
    ...                makes the name disappear again.
    [Tags]    file-upload    positive    dynamic-element
    Upload Event Details File    jazz-night-programme.pdf
    Uploaded Details File Should Be    jazz-night-programme.pdf
    Capture Evidence    UI-009-details-document-uploaded

    Remove Details File
    No Details File Should Be Uploaded

UI-010 Event Details Rejects A File In The Wrong Format
    [Documentation]    File validation: the details field only takes PDF or Word documents,
    ...                so an image chosen there must be rejected and nothing uploaded.
    [Tags]    file-upload    file-validation    negative
    Upload Event Details File    jazz-night.jpg
    Details File Error Should Be    Please choose a PDF or Word document
    No Details File Should Be Uploaded
    Capture Evidence    UI-010-details-wrong-format-rejected

UI-F01 Event Image Rejects A File That Is Not An Image
    [Documentation]    Failure-oriented: a text file chosen as the event image must be
    ...                rejected with the exact message, and nothing must be uploaded.
    [Tags]    image-upload    file-validation    negative    failure-oriented
    Upload Event Image    not-an-image.txt
    Event Image Error Should Be    Please choose a JPG, PNG or WEBP image
    No Event Image Should Be Uploaded
    Capture Evidence    UI-F01-unsupported-file-rejected


*** Keywords ***
Open Event Form With Details Above The Image
    Open New Event Form
    Enter Event Details Above The Image
