*** Settings ***
Documentation       A single event's page (/events/<id>) and its "Purchase Tickets" dialog.
Library             Browser
Resource            ../common.resource


*** Variables ***
${PURCHASE_TICKETS_BUTTON}      role=button[name="PURCHASE TICKETS"]
${TICKET_DIALOG}                role=dialog[name="Purchase Tickets"]
${CLOSE_DIALOG_BUTTON}          ${TICKET_DIALOG} >> role=button[name="Close"]
${INCREASE_QUANTITY_BUTTON}     ${TICKET_DIALOG} >> role=button[name="Increase quantity"]
# The total's value sits right after its "TOTAL AMOUNT" label.
${TOTAL_AMOUNT}                 ${TICKET_DIALOG} >> text=TOTAL AMOUNT >> xpath=following-sibling::span


*** Keywords ***
Open Event Page
    [Arguments]    ${event_id}
    Open Site Page    /events/${event_id}

Open Ticket Dialog
    Click    ${PURCHASE_TICKETS_BUTTON}

Close Ticket Dialog
    Click    ${CLOSE_DIALOG_BUTTON}

Increase Ticket Quantity
    Click    ${INCREASE_QUANTITY_BUTTON}

Ticket Dialog Should Be Open
    Wait For Elements State    ${TICKET_DIALOG}    visible

Ticket Dialog Should Be Closed
    Wait For Elements State    ${TICKET_DIALOG}    detached

Ticket Dialog Should List
    [Arguments]    ${ticket_type}    ${price}
    Get Text    ${TICKET_DIALOG}    contains    ${ticket_type}
    Get Text    ${TICKET_DIALOG}    contains    GHS${price}

Total Amount Should Be
    [Arguments]    ${amount}
    Get Text    ${TOTAL_AMOUNT}    ==    GHS${amount}
