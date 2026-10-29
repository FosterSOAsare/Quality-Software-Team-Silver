*** Settings ***
Documentation       Event page and its "Purchase Tickets" dialog.
...                 Each test creates its own event through the API and deletes it afterwards.
...                 The dialog is never submitted, so no payment link or email is created.
Library             String
Resource            ../../resources/common.resource
Resource            ../../resources/api/api_client.resource
Resource            ../../resources/pages/event_details_page.resource

Suite Setup         Run Keywords    Start Browser    AND    Start API Sessions
Suite Teardown      Run Keywords    Close Browser    AND    Delete All Sessions
Test Teardown       Delete Created Event
Test Tags           ui    events


*** Test Cases ***
UI-007 Ticket Dialog Shows Event Tickets And Closes
    [Documentation]    State verification: an event created through the API is shown on its page.
    ...                Dialog: opens with the right ticket, total updates, then closes.
    [Tags]    dialog    state-verification    dynamic-element    positive
    ${event}=    Valid Event Payload
    ${created}=    Create Event    ${event}
    Open Event Page    ${created.json()}[_id]
    ${title_on_screen}=    Convert To Upper Case    ${event}[title]
    Page Heading Should Be    ${title_on_screen}

    Open Ticket Dialog
    Ticket Dialog Should Be Open
    Ticket Dialog Should List    General Admission    150
    Total Amount Should Be    150

    Increase Ticket Quantity
    Total Amount Should Be    300
    Capture Evidence    UI-007-ticket-dialog-open

    Close Ticket Dialog
    Ticket Dialog Should Be Closed
    Page Heading Should Be    ${title_on_screen}
