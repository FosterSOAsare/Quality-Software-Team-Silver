*** Settings ***
Documentation       The booking page (/book): room selection, calendar and guest details.
Library             Browser
Library             DateTime
Resource            ../common.resource


*** Variables ***
${BOOKING_PATH}             /book
${ROOM_TYPE_DROPDOWN}       select[name="itemType"]
${ROOM_NUMBER_DROPDOWN}     select[name="item"]
${FIRST_NAME_INPUT}         input[name="firstName"]
${LAST_NAME_INPUT}          input[name="lastName"]
${EMAIL_INPUT}              input[name="email"]
${SUBMIT_BOOKING_BUTTON}    role=button[name="COMPLETE BOOKING REQUEST"]
# The calendar has no test id yet, so it is found through its weekday header row.
${CALENDAR}                 xpath=//div[div[normalize-space()='SU']]


*** Keywords ***
Open Booking Page
    [Documentation]    The page checks room availability as soon as it opens. While it does,
    ...                the submit button reads "CHECKING AVAILABILITY...", so this waits for the
    ...                normal button before the test starts.
    Open Site Page    ${BOOKING_PATH}
    Wait For Elements State    ${SUBMIT_BOOKING_BUTTON}    enabled

Select Room Type
    [Documentation]    Changing the room type makes the page re-check availability. While it
    ...                does, the submit button reads "CHECKING AVAILABILITY...", so this waits
    ...                for the normal button to come back before moving on.
    [Arguments]    ${room_type}
    Select Options By    ${ROOM_TYPE_DROPDOWN}    label    ${room_type}
    Wait For Elements State    ${SUBMIT_BOOKING_BUTTON}    enabled

Selected Room Type Should Be
    [Arguments]    ${room_type}
    Get Selected Options    ${ROOM_TYPE_DROPDOWN}    label    ==    ${room_type}

Selected Room Number Should Be
    [Arguments]    ${room_number}
    Get Selected Options    ${ROOM_NUMBER_DROPDOWN}    label    ==    ${room_number}

Capture Room Type Options Evidence
    [Documentation]    Evidence only. A dropdown's open list is drawn by the browser outside the
    ...                page, so a page screenshot cannot show it. For the screenshot, the dropdown
    ...                is expanded into a list showing the same options, then folded back.
    [Arguments]    ${name}
    ${capture}=    Evidence Capture Is On
    IF    ${capture}
        Evaluate JavaScript    ${ROOM_TYPE_DROPDOWN}    (dropdown) => { dropdown.size = dropdown.options.length }
        Capture Evidence    ${name}
        Evaluate JavaScript    ${ROOM_TYPE_DROPDOWN}    (dropdown) => { dropdown.size = 0 }
    END

Calendar Day
    [Documentation]    Returns the locator of one day button in the month shown.
    [Arguments]    ${day}
    RETURN    ${CALENDAR}//button[normalize-space()='${day}']

Past Days Should Be Disabled
    [Documentation]    Every day of this month before today must be unclickable.
    ${today}=    Get Current Date    result_format=%d
    ${today}=    Convert To Integer    ${today}
    IF    ${today} == 1
        Log    Today is the 1st, so there are no past days in this month to check.    WARN
    END
    FOR    ${day}    IN RANGE    1    ${today}
        ${past_day}=    Calendar Day    ${day}
        Wait For Elements State    ${past_day}    disabled
    END

Enter Guest Details
    [Arguments]    ${first_name}    ${last_name}    ${email}
    Fill Text    ${FIRST_NAME_INPUT}    ${first_name}
    Fill Text    ${LAST_NAME_INPUT}    ${last_name}
    Fill Text    ${EMAIL_INPUT}    ${email}

Enter First Name
    [Arguments]    ${first_name}
    Fill Text    ${FIRST_NAME_INPUT}    ${first_name}

Clear First Name
    Clear Text    ${FIRST_NAME_INPUT}

First Name Should Be
    [Arguments]    ${expected_value}
    Get Property    ${FIRST_NAME_INPUT}    value    ==    ${expected_value}

Submit Booking
    Click    ${SUBMIT_BOOKING_BUTTON}
