*** Settings ***
Documentation       Bookings: access control and error handling. No bookings are created.
Resource            ../../resources/api/api_client.resource

Suite Setup         Start API Sessions
Suite Teardown      Delete All Sessions
Test Tags           api    bookings


*** Test Cases ***
API-003 Bookings List Requires An Admin Token
    [Tags]    negative    authorization
    ${response}=    Get All Bookings Without Token
    Error Message Should Be    ${response}    Missing or invalid token

API-004 Unknown Booking Reference Returns Not Found
    [Tags]    negative    error-handling
    ${reference}=    Unique Booking Reference
    ${response}=    Get Booking By Reference    ${reference}    expected_status=404
    Error Message Should Be    ${response}    Booking not found
