*** Settings ***
Documentation       The admin login page (/admin/login), and a saved admin session
...                 so admin tests log in once per suite instead of once per test.
Library             Browser
Library             OperatingSystem
Resource            ../common.resource


*** Variables ***
${ADMIN_LOGIN_PATH}     /admin/login
${PASSCODE_INPUT}       css=input[type="password"]
${LOGIN_BUTTON}         role=button[name="LOGIN TO DASHBOARD"]


*** Keywords ***
Start Admin Session
    [Documentation]    Run as Suite Setup. Logs in through the UI once and saves the
    ...                result (the token the app keeps in local storage) to a file.
    ...                Tests then open pages with Open Site Page As Admin.
    Should Not Be Empty    ${ADMIN_PASSCODE}    Set ADMIN_PASSCODE in .env to run admin tests.
    Start Browser
    Open Site Page    ${ADMIN_LOGIN_PATH}
    Log In As Admin
    ${session_file}=    Save Storage State
    Set Suite Variable    ${ADMIN_SESSION}    ${session_file}
    Close Context

End Admin Session
    [Documentation]    Run as Suite Teardown. Closes the browser and deletes the saved
    ...                login file, so the admin token does not stay on disk after the run.
    Close Browser
    ${session_file}=    Get Variable Value    ${ADMIN_SESSION}
    IF    $session_file    Remove File    ${session_file}

Log In As Admin
    # Fill Secret keeps the passcode out of log.html.
    Fill Secret    ${PASSCODE_INPUT}    $ADMIN_PASSCODE
    Click    ${LOGIN_BUTTON}
    Page Url Should End With    /bookings

Open Site Page As Admin
    [Arguments]    ${path}
    Open Site Page    ${path}    storage_state=${ADMIN_SESSION}
