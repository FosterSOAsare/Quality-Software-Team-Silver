*** Settings ***
Documentation       Admin event form: the ticket quantity number input.
...                 Every field is filled with valid data except the one under test, so the
...                 form is never valid when saved and nothing is created on the live site.
Resource            ../../resources/common.resource
Resource            ../../resources/pages/event_form_page.resource

Suite Setup         Start Admin Session
Suite Teardown      End Admin Session
Test Setup          Open New Event Form
Test Tags           ui    events    admin


*** Variables ***
${QUANTITY_TOO_LOW_ERROR}       Quantity must be at least 1


*** Test Cases ***
UI-006 Ticket Quantity Limit Must Be At Least 1
    [Documentation]    Number input boundary: 0 is rejected, 1 is accepted.
    ...                The field only exists while the ticket has a quantity limit.
    [Tags]    number-input    boundary    dynamic-element    negative
    Enter Valid Event Details
    Add Ticket    General Admission    50
    Add Quantity Limit
    Quantity Limit Field Should Be Shown

    Enter Quantity Limit    0
    Save Event
    Error Message Should Be Shown    ${QUANTITY_TOO_LOW_ERROR}
    Capture Evidence    UI-006-quantity-0-rejected

    Enter Quantity Limit    1
    Error Message Should Not Be Shown    ${QUANTITY_TOO_LOW_ERROR}

    Make Ticket Unlimited
    Quantity Limit Field Should Be Hidden
