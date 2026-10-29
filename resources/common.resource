*** Settings ***
Documentation       Browser setup and keywords shared by every UI suite.
Library             Browser
Variables           ../config/env.py


*** Variables ***
# True once every animated element on screen has finished fading in. Animated elements are the
# ones with an inline opacity. Elements only just peeking in at the edge (under 150px visible)
# are ignored: the site does not fade those in until you scroll further.
${SECTIONS_ON_SCREEN_FULLY_VISIBLE}
...    () => [...document.querySelectorAll('[style]')]
...    .filter(el => el.style.opacity !== '')
...    .filter(el => { const box = el.getBoundingClientRect(); const shown = Math.min(box.bottom, innerHeight) - Math.max(box.top, 0); return box.width > 0 && shown >= Math.min(box.height, 150); })
...    .every(el => getComputedStyle(el).opacity === '1')


*** Keywords ***
Start Browser
    [Documentation]    Opens one browser for the whole suite. Run as Suite Setup.
    New Browser    ${BROWSER}    headless=${HEADLESS}
    Set Browser Timeout    ${TIMEOUT}

Open Site Page
    [Documentation]    Opens ${path} in a brand-new context (fresh cookies and storage),
    ...                so no test can be affected by another. Run as Test Setup.
    ...                Pass a saved ${storage_state} to start already logged in.
    [Arguments]    ${path}    ${storage_state}=${None}
    New Context    viewport={'width': 1440, 'height': 900}    storageState=${storage_state}
    New Page    ${BASE_URL}${path}

Page Heading Should Be
    [Documentation]    Compares the heading as it appears on screen (after CSS such as uppercase).
    [Arguments]    ${expected_heading}
    Get Text    h1    ==    ${expected_heading}

Page Url Should End With
    [Documentation]    Waits up to the browser timeout for the URL, because some
    ...                navigation only happens after a server call (e.g. login).
    ...                See docs/failure-log.md, FL-005.
    [Arguments]    ${path}
    Wait For Condition    Url    ==    ${BASE_URL}${path}

Error Message Should Be Shown
    [Arguments]    ${message}
    Wait For Elements State    text="${message}"    visible

Error Message Should Not Be Shown
    [Arguments]    ${message}
    Wait For Elements State    text="${message}"    detached

Evidence Capture Is On
    [Documentation]    True when CAPTURE_EVIDENCE is on. Accepts both True (from .env)
    ...                and "true" (from --variable).
    RETURN    ${{ str($CAPTURE_EVIDENCE).lower() == 'true' }}

Capture Evidence
    [Documentation]    Saves a screenshot of the browser page (page only, no desktop or clock)
    ...                to evidence/screenshots/<name>.png. Only runs when CAPTURE_EVIDENCE is
    ...                true, so normal runs are not slowed down.
    [Arguments]    ${name}
    ${capture}=    Evidence Capture Is On
    IF    ${capture}
        Wait For Page To Settle
        Take Screenshot    filename=${EVIDENCE_DIR}/${name}
    END

Wait For Page To Settle
    [Documentation]    Used before evidence screenshots only. The site fades sections in as they
    ...                scroll into view, and draws its own mouse cursor over the page. This hides
    ...                the cursor and waits until every faded section on screen is fully visible,
    ...                so the screenshot shows the finished page.
    Add Style Tag    .custom-cursor-container { display: none !important; }
    Wait For Function    ${SECTIONS_ON_SCREEN_FULLY_VISIBLE}    timeout=10s
