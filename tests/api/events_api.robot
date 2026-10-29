*** Settings ***
Documentation       Events: full create, read, update, delete cycle and validation.
...                 Every event a test creates is deleted again in the teardown.
Resource            ../../resources/api/api_client.resource

Suite Setup         Start API Sessions
Suite Teardown      Delete All Sessions
Test Teardown       Delete Created Event
Test Tags           api    events


*** Test Cases ***
API-005 Event Can Be Created Read Updated And Deleted
    [Tags]    crud    schema    positive
    ${payload}=    Valid Event Payload
    ${created}=    Create Event    ${payload}
    ${event_id}=    Set Variable    ${created.json()}[_id]

    ${fetched}=    Get Event    ${event_id}
    Response Should Match Schema    ${fetched.json()}    event
    Should Be Equal    ${fetched.json()}[title]    ${payload}[title]
    Should Be Equal    ${fetched.json()}[tickets][0][type]    General Admission

    ${new_title}=    Unique Event Title
    ${changes}=    Create Dictionary    title=${new_title}
    ${updated}=    Update Event    ${event_id}    ${changes}
    Should Be Equal    ${updated.json()}[title]    ${new_title}

    Delete Event    ${event_id}
    ${gone}=    Get Event    ${event_id}    expected_status=404
    Error Message Should Be    ${gone}    Event not found

API-006 Event With A Past Date Is Rejected
    [Documentation]    Boundary: yesterday is the latest date that must be rejected
    ...                (events may be dated today, as the event form allows).
    [Tags]    negative    boundary    data-validation
    ${payload}=    Valid Event Payload
    ${yesterday}=    Past Date    days_ago=1
    Set To Dictionary    ${payload}    date=${yesterday}
    ${response}=    Create Event    ${payload}    expected_status=400
    Error Message Should Be    ${response}    Event date cannot be in the past
