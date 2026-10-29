*** Settings ***
Documentation       The admin "Create New Event" form (/events/new).
Library             Browser
Library             ../../libraries/TestDataFactory.py
Resource            admin_login_page.resource


*** Variables ***
${NEW_EVENT_PATH}                   /events/new
${TITLE_INPUT}                      input[name="title"]
${DATE_INPUT}                       input[name="date"]
${TIME_INPUT}                       input[name="time"]
${LOCATION_INPUT}                   input[name="location"]
${DESCRIPTION_TEXT_AREA}            textarea[name="desc"]
${EVENT_IMAGE_LABEL}                css=label[for="event-image"]
${EVENT_IMAGE_INPUT}                css=[data-testid="event-image-input"]
${EVENT_IMAGE_FILE_NAME}            css=[data-testid="event-image-file-name"]
${EVENT_IMAGE_PREVIEW}              css=[data-testid="event-image-selected"] img
${EVENT_IMAGE_ERROR}                css=[data-testid="event-image-error"]
${DETAILS_FILE_LABEL}               css=label[for="event-details-file"]
${DETAILS_FILE_INPUT}               css=[data-testid="event-details-file-input"]
${DETAILS_FILE_NAME}                css=[data-testid="event-details-file-file-name"]
${DETAILS_FILE_ERROR}               css=[data-testid="event-details-file-error"]
${DETAILS_FILE_REMOVE_BUTTON}       css=[data-testid="event-details-file-remove"]
${TEST_FILES}                       ${CURDIR}/../../test-data/files
${ADD_TICKET_BUTTON}                role=button[name="ADD TICKET"]
${TICKET_TYPE_INPUT}                input[name="tickets.0.type"]
${TICKET_PRICE_INPUT}               input[name="tickets.0.price"]
${ADD_QUANTITY_LIMIT_BUTTON}        role=button[name="ADD QUANTITY LIMIT"]
${MAKE_UNLIMITED_BUTTON}            role=button[name="Make Unlimited"]
${QUANTITY_LIMIT_INPUT}             input[name="tickets.0.totalQuantity"]
${SAVE_EVENT_BUTTON}                role=button[name="SAVE EVENT"]


*** Keywords ***
Open New Event Form
    Open Site Page As Admin    ${NEW_EVENT_PATH}

Enter Event Details Above The Image
    [Documentation]    Fills title, date, time and location from test-data/sample_event.json,
    ...                with a unique [TEST] title.
    ${event}=    Sample Event
    ${title}=    Unique Event Title
    ${date}=    Future Date    days_ahead=30
    Fill Text    ${TITLE_INPUT}    ${title}
    Fill Text    ${DATE_INPUT}    ${date}
    Fill Text    ${TIME_INPUT}    ${event}[time]
    Fill Text    ${LOCATION_INPUT}    ${event}[location]

Enter Valid Event Details
    [Documentation]    Fills every event field from test-data/sample_event.json, so a test
    ...                can make exactly one field invalid.
    ${event}=    Sample Event
    Enter Event Details Above The Image
    Fill Text    ${DESCRIPTION_TEXT_AREA}    ${event}[desc]
    Upload Event Image    ${event}[imageFile]
    Uploaded Event Image Should Be    ${event}[imageFile]

Upload Event Image
    [Documentation]    Scrolls to the image field, as a user would, then picks a file
    ...                from test-data/files/.
    [Arguments]    ${file_name}
    Scroll To Element    ${EVENT_IMAGE_LABEL}
    Upload File By Selector    ${EVENT_IMAGE_INPUT}    ${TEST_FILES}/${file_name}

Uploaded Event Image Should Be
    [Documentation]    Waits for the upload to finish (up to the browser timeout), then
    ...                checks the file name and that the preview comes from Cloudinary.
    [Arguments]    ${file_name}
    Wait For Elements State    ${EVENT_IMAGE_FILE_NAME}    visible
    Get Text    ${EVENT_IMAGE_FILE_NAME}    ==    ${file_name}
    Get Attribute    ${EVENT_IMAGE_PREVIEW}    src    starts    https://res.cloudinary.com/

Event Image Error Should Be
    [Arguments]    ${message}
    Get Text    ${EVENT_IMAGE_ERROR}    ==    ${message}

No Event Image Should Be Uploaded
    Wait For Elements State    ${EVENT_IMAGE_FILE_NAME}    detached

Upload Event Details File
    [Documentation]    Scrolls to the event details field, as a user would, then picks a
    ...                file from test-data/files/.
    [Arguments]    ${file_name}
    Scroll To Element    ${DETAILS_FILE_LABEL}
    Upload File By Selector    ${DETAILS_FILE_INPUT}    ${TEST_FILES}/${file_name}

Details File Error Should Be
    [Arguments]    ${message}
    Get Text    ${DETAILS_FILE_ERROR}    ==    ${message}

Uploaded Details File Should Be
    [Documentation]    Waits for the upload to finish, then checks the file name shown.
    [Arguments]    ${file_name}
    Wait For Elements State    ${DETAILS_FILE_NAME}    visible
    Get Text    ${DETAILS_FILE_NAME}    ==    ${file_name}

Remove Details File
    Click    ${DETAILS_FILE_REMOVE_BUTTON}

No Details File Should Be Uploaded
    Wait For Elements State    ${DETAILS_FILE_NAME}    detached

Add Ticket
    [Arguments]    ${ticket_type}    ${price}
    Click    ${ADD_TICKET_BUTTON}
    Fill Text    ${TICKET_TYPE_INPUT}    ${ticket_type}
    Fill Text    ${TICKET_PRICE_INPUT}    ${price}

Add Quantity Limit
    Click    ${ADD_QUANTITY_LIMIT_BUTTON}

Make Ticket Unlimited
    Click    ${MAKE_UNLIMITED_BUTTON}

Enter Quantity Limit
    [Arguments]    ${quantity}
    Fill Text    ${QUANTITY_LIMIT_INPUT}    ${quantity}

Quantity Limit Field Should Be Shown
    Wait For Elements State    ${QUANTITY_LIMIT_INPUT}    visible

Quantity Limit Field Should Be Hidden
    Wait For Elements State    ${QUANTITY_LIMIT_INPUT}    detached

Save Event
    Click    ${SAVE_EVENT_BUTTON}
