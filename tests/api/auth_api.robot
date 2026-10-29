*** Settings ***
Documentation       Admin login: POST /auth/login.
Resource            ../../resources/api/api_client.resource

Suite Setup         Start API Sessions
Suite Teardown      Delete All Sessions
Test Tags           api    auth


*** Test Cases ***
API-001 Admin Login With Correct Passcode Returns A Token
    [Tags]    positive    schema    headers    smoke
    ${response}=    Log In With Passcode    ${ADMIN_PASSCODE}
    Response Should Match Schema    ${response.json()}    login_response
    Should Start With    ${response.headers}[Content-Type]    application/json

API-002 Admin Login With Wrong Passcode Is Rejected
    [Tags]    negative    auth
    ${response}=    Log In With Passcode    wrong-passcode    expected_status=401
    Error Message Should Be    ${response}    Invalid passcode
    Dictionary Should Not Contain Key    ${response.json()}    token
