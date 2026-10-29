*** Settings ***
Documentation       The contact page (/contact): the enquiry form.
...                 Note: a successful submit sends a real email, so tests avoid it.
Library             Browser
Resource            ../common.resource


*** Variables ***
${CONTACT_PATH}             /contact
${NAME_INPUT}               css=[placeholder="Full Name"]
${EMAIL_INPUT}              css=[placeholder="email@example.com"]
${SUBJECT_INPUT}            css=[placeholder="How can we help?"]
${MESSAGE_TEXT_AREA}        css=textarea[placeholder="Your message here..."]
${PRIVACY_CHECKBOX}         id=privacy
${SEND_INQUIRY_BUTTON}      role=button[name="SEND INQUIRY"]


*** Keywords ***
Open Contact Page
    Open Site Page    ${CONTACT_PATH}

Enter Contact Details
    [Arguments]    ${name}    ${email}    ${subject}    ${message}
    Fill Text    ${NAME_INPUT}    ${name}
    Fill Text    ${EMAIL_INPUT}    ${email}
    Fill Text    ${SUBJECT_INPUT}    ${subject}
    Enter Message    ${message}

Enter Message
    [Arguments]    ${message}
    Fill Text    ${MESSAGE_TEXT_AREA}    ${message}

Message Should Be
    [Arguments]    ${expected_message}
    Get Property    ${MESSAGE_TEXT_AREA}    value    ==    ${expected_message}

Agree To Privacy Terms
    Check Checkbox    ${PRIVACY_CHECKBOX}

Send Inquiry
    Click    ${SEND_INQUIRY_BUTTON}
