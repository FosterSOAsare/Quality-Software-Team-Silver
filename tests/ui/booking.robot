*** Settings ***
Documentation       Booking page: room selection, calendar rules and guest detail validation.
...                 None of these tests submits a valid booking, so no data is created.
Resource            ../../resources/common.resource
Resource            ../../resources/pages/booking_page.resource

Suite Setup         Start Browser
Suite Teardown      Close Browser
Test Setup          Open Booking Page
Test Tags           ui    booking


*** Test Cases ***
UI-002 Room Type Dropdown Updates Room Numbers
    [Documentation]    Choosing a room type shows only the rooms of that type.
    [Tags]    dropdown    positive    smoke
    Selected Room Type Should Be    THE STANDARD ROOM
    Capture Room Type Options Evidence    UI-002-room-type-options

    Select Room Type    THE DELUXE ROOM
    Selected Room Type Should Be    THE DELUXE ROOM
    Selected Room Number Should Be    Room 201
    Capture Evidence    UI-002-room-type-after

UI-003 Calendar Disables Past Dates
    [Documentation]    Guests cannot pick a check-in date in the past.
    [Tags]    date-picker    date-validation    negative
    Past Days Should Be Disabled
    Capture Evidence    UI-003-past-days-disabled

UI-004 Guest Details Can Be Edited Cleared And Validated
    [Documentation]    Text input: enter, edit and clear a value, then submit invalid details.
    ...                "jane@example" passes the browser's own email check but not the app's
    ...                (no top-level domain), so the app's message is what we verify.
    ...                See docs/failure-log.md, FL-002.
    [Tags]    text-input    field-validation    negative
    Enter First Name    Jane
    First Name Should Be    Jane
    Enter First Name    Janet
    First Name Should Be    Janet
    Clear First Name
    First Name Should Be    ${EMPTY}

    Enter Guest Details    first_name=J    last_name=D    email=jane@example
    Submit Booking
    Error Message Should Be Shown    First name must be at least 2 characters
    Error Message Should Be Shown    Last name must be at least 2 characters
    Error Message Should Be Shown    Please enter a valid email address
    Capture Evidence    UI-004-guest-details-validation
