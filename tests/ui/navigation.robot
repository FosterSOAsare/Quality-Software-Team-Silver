*** Settings ***
Documentation       Data-driven: the same navigation check runs once per header link.
...                 Each row below is reported as its own test.
Resource            ../../resources/common.resource
Resource            ../../resources/pages/site_header.resource

Suite Setup         Start Browser
Suite Teardown      Close Browser
Test Setup          Open Site Page    /
Test Template       Header Link Should Open Page
Test Tags           ui    navigation    data-driven    smoke


*** Test Cases ***                                  LINK          PATH          HEADING
UI-001.1 Rooms Link Opens Rooms Page                ROOMS         /rooms        ROOMS
UI-001.2 Contact Link Opens Contact Page            CONTACT       /contact      CONTACT US
UI-001.3 Book Link Opens Booking Page               BOOK          /book         BOOK YOUR EXPERIENCE


*** Keywords ***
Header Link Should Open Page
    [Arguments]    ${link_text}    ${expected_path}    ${expected_heading}
    Go To Page Using Header    ${link_text}
    Page Url Should End With    ${expected_path}
    Page Heading Should Be    ${expected_heading}
    Header Link Should Be Active    ${link_text}
    Capture Evidence    UI-001-${link_text}-link
