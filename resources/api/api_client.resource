*** Settings ***
Documentation       Keyword-level client for the Amethyst API.
...                 Tests call these keywords and never send raw HTTP requests themselves.
Library             RequestsLibrary
Library             Collections
Library             String
Library             ../../libraries/TestDataFactory.py
Library             ../../libraries/SchemaValidator.py
Variables           ../../config/env.py


*** Keywords ***
# ---------- Sessions ----------

Start API Sessions
    [Documentation]    Run as Suite Setup. Creates two sessions:
    ...                "public" sends no token, "admin" sends the admin token.
    Should Not Be Empty    ${ADMIN_PASSCODE}    Set ADMIN_PASSCODE in .env to run API tests.
    Create Session    public    ${API_BASE_URL}    timeout=${API_TIMEOUT}    verify=${True}
    ${response}=    Log In With Passcode    ${ADMIN_PASSCODE}
    # The header holds the token, so it is built while logging is turned down.
    ${previous_level}=    Set Log Level    WARN
    ${headers}=    Create Dictionary    Authorization=Bearer ${response.json()}[token]
    Create Session    admin    ${API_BASE_URL}    headers=${headers}    timeout=${API_TIMEOUT}    verify=${True}
    Set Log Level    ${previous_level}

Send Request
    [Documentation]    Every API call goes through here. Logging is turned down for the call
    ...                itself, because the library would otherwise write the token and passcode
    ...                into log.html. The response is logged afterwards, with the token masked.
    [Arguments]    ${session}    ${method}    ${path}    ${expected_status}    &{options}
    ${previous_level}=    Set Log Level    WARN
    TRY
        ${response}=    Run Keyword    ${method} On Session    ${session}    ${path}
        ...    expected_status=${expected_status}    &{options}
    FINALLY
        Set Log Level    ${previous_level}
    END
    ${safe_body}=    Replace String Using Regexp    ${response.text}    "token":"[^"]+"    "token":"***"
    Log    ${method} ${path} -> ${response.status_code}\n${safe_body}
    RETURN    ${response}

Error Message Should Be
    [Arguments]    ${response}    ${expected_message}
    Should Be Equal    ${response.json()}[message]    ${expected_message}

# ---------- Auth ----------

Log In With Passcode
    [Arguments]    ${passcode}    ${expected_status}=200
    # The body holds the passcode, so it is built while logging is turned down.
    ${previous_level}=    Set Log Level    WARN
    ${body}=    Create Dictionary    passcode=${passcode}
    Set Log Level    ${previous_level}
    ${response}=    Send Request    public    POST    /auth/login    ${expected_status}    json=${body}
    RETURN    ${response}


# ---------- Bookings ----------

Get All Bookings Without Token
    ${response}=    Send Request    public    GET    /bookings    401
    RETURN    ${response}

Get Booking By Reference
    [Arguments]    ${reference}    ${expected_status}=200
    ${response}=    Send Request    public    GET    /bookings/${reference}    ${expected_status}
    RETURN    ${response}


# ---------- Events ----------

Create Event
    [Documentation]    If the event is created, its id is remembered so the test
    ...                teardown (Delete Created Event) can remove it.
    [Arguments]    ${payload}    ${expected_status}=201
    ${response}=    Send Request    admin    POST    /events    ${expected_status}    json=${payload}
    IF    ${response.status_code} == 201
        Set Test Variable    ${CREATED_EVENT_ID}    ${response.json()}[_id]
    END
    RETURN    ${response}

Get Event
    [Arguments]    ${event_id}    ${expected_status}=200
    ${response}=    Send Request    public    GET    /events/${event_id}    ${expected_status}
    RETURN    ${response}

Update Event
    [Arguments]    ${event_id}    ${changes}
    ${response}=    Send Request    admin    PUT    /events/${event_id}    200    json=${changes}
    RETURN    ${response}

Delete Event
    [Arguments]    ${event_id}
    ${response}=    Send Request    admin    DELETE    /events/${event_id}    204
    RETURN    ${response}

Delete Created Event
    [Documentation]    Run as Test Teardown. Removes the event this test created, if any.
    ...                Safe to run when the test already deleted it.
    ${event_id}=    Get Variable Value    ${CREATED_EVENT_ID}
    IF    $event_id
        Send Request    admin    DELETE    /events/${event_id}    anything
    END
