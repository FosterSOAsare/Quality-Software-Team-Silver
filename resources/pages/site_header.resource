*** Settings ***
Documentation       The navigation bar shown at the top of every page.
Library             Browser


*** Variables ***
${MAIN_NAVIGATION}      css=header nav


*** Keywords ***
Go To Page Using Header
    [Arguments]    ${link_text}
    Click    ${MAIN_NAVIGATION} >> role=link[name="${link_text}"]

Header Link Should Be Active
    [Documentation]    The active link is marked with aria-current="page".
    [Arguments]    ${link_text}
    Get Attribute    ${MAIN_NAVIGATION} >> role=link[name="${link_text}"]    aria-current    ==    page
