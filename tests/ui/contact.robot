*** Settings ***
Documentation       Contact page: the message text area.
...                 "Send Inquiry" is only clicked while the message is too short, so the
...                 form is always rejected and no real email goes out.
Resource            ../../resources/common.resource
Resource            ../../resources/pages/contact_page.resource

Suite Setup         Start Browser
Suite Teardown      Close Browser
Test Setup          Open Contact Page
Test Tags           ui    contact


*** Variables ***
${MESSAGE_TOO_SHORT_ERROR}      Message must be at least 10 characters


*** Test Cases ***
UI-005 Message Text Area Enforces Minimum Length And Keeps Multi-Line Text
    [Documentation]    Boundary: 9 characters is rejected, exactly 10 is accepted.
    ...                After the first submit, the form re-checks the field as you type.
    ...                Every other field is valid, so the message is the only error shown.
    [Tags]    text-area    boundary    negative
    Enter Contact Details    Jane Doe    jane@example.com    Room enquiry    123456789
    Agree To Privacy Terms
    Send Inquiry
    Error Message Should Be Shown    ${MESSAGE_TOO_SHORT_ERROR}
    Capture Evidence    UI-005-message-9-characters-rejected

    Enter Message    1234567890
    Error Message Should Not Be Shown    ${MESSAGE_TOO_SHORT_ERROR}

    Enter Message    Line one\nLine two\nLine three
    Message Should Be    Line one\nLine two\nLine three
    Capture Evidence    UI-005-message-multi-line-accepted
