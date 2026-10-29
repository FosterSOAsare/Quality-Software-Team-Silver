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
${IMAGE_URL_INPUT}                  input[name="leadImage"]
${DESCRIPTION_TEXT_AREA}            textarea[name="desc"]
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

Enter Valid Event Details
    [Documentation]    Fills every event field with valid, clearly marked test data,
    ...                so a test can make exactly one field invalid.
    ${title}=    Unique Event Title
    ${date}=    Future Date    days_ahead=30
    Fill Text    ${TITLE_INPUT}    ${title}
    Fill Text    ${DATE_INPUT}    ${date}
    Fill Text    ${TIME_INPUT}    19:00
    Fill Text    ${LOCATION_INPUT}    Rooftop Lounge
    Fill Text    ${IMAGE_URL_INPUT}    https://images.unsplash.com/photo-1511192336575-5a79af67a629?q=80&w=1200&auto=format&fit=crop
    Fill Text    ${DESCRIPTION_TEXT_AREA}    Automated test event. Safe to delete.

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
