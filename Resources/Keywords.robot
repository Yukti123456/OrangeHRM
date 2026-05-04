*** Settings ***
Library    SeleniumLibrary
Library             OperatingSystem
Library             Collections
Resource            /Resources/Variables.robot
*** Keywords ***
Open Browser And Navigate To Login Page
    [Documentation]     Opens the browser once for the entire suite.
    Create Directory    ${SCREENSHOT_DIR}
    Open Browser     ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Set Selenium Page Load Timeout    ${PAGE_LOAD_TIMEOUT}
    Wait Until Login Page Is Ready

Navigate To Login Page
    [Documentation]    Navigates to login page before each test and clears any leftover state.
    Go To    ${BASE_URL}
    Wait Until Login Page Is Ready

Wait Until Login Page Is Ready
    [Documentation]    Waits for all key login page elements to be visible and interactive.
    Wait Until Element Is Visible    ${USERNAME_FIELD}    timeout=${EXPLICIT_WAIT}
    Wait Until Element Is Enabled    ${USERNAME_FIELD}    timeout=${EXPLICIT_WAIT}
    Wait Until Element Is Visible    ${PASSWORD_FIELD}    timeout=${EXPLICIT_WAIT}
    Wait Until Element Is Enabled    ${LOGIN_BUTTON}      timeout=${EXPLICIT_WAIT}

Capture Screenshot On Failure
    [Documentation]    Captures a screenshot if the test failed.
    Run Keyword If Test Failed
    ...    Capture Page Screenshot
    ...    ${SCREENSHOT_DIR}/${TEST NAME}-FAILED.png

Fill Login Form
    [Arguments]    ${username}    ${password}
    [Documentation]    Clears fields, types credentials, and clicks Login.
    Clear Element Text    ${USERNAME_FIELD}
    Input Text           ${USERNAME_FIELD}    ${username}
    Clear Element Text    ${PASSWORD_FIELD}
    Input Text           ${PASSWORD_FIELD}    ${password}
    Click Element        ${LOGIN_BUTTON}

Wait For Dashboard
    [Documentation]    Confirms successful redirect to the dashboard.
    Wait Until Element Is Visible    ${DASHBOARD_HEADER}    timeout=${EXPLICIT_WAIT}
    Location Should Contain    dashboard

Wait For Error Message
    [Documentation]    Waits for the inline error alert to appear after a bad login.
    Wait Until Element Is Visible    ${ERROR_ALERT}      timeout=${EXPLICIT_WAIT}
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=${EXPLICIT_WAIT}

Wait For Required Field Error
    [Arguments]    ${locator}
    [Documentation]    Waits for a field-level "Required" validation message.
    Wait Until Element Is Visible    ${locator}    timeout=${EXPLICIT_WAIT}

Logout If Logged In
    [Documentation]    Safely logs out; ignores errors if already on login page.
    ${logged_in}=    Run Keyword And Return Status    Element Should Be Visible    ${USER_DROPDOWN}
    Run Keyword If    ${logged_in}    Perform Logout

Perform Logout
    Click Element    ${USER_DROPDOWN}
    Wait Until Element Is Visible    ${LOGOUT_OPTION}    timeout=${EXPLICIT_WAIT}
    Click Element    ${LOGOUT_OPTION}
    Wait Until Login Page Is Ready


Error Message Should Be
    [Arguments]    ${expected_text}
    [Documentation]    Asserts the visible error alert contains the expected text.
    ${actual}=    Get Text    ${ERROR_MESSAGE}
    Should Contain    ${actual}    ${expected_text}
    Log     Error message verified: "${actual}"    level=INFO

Field Error Should Say Required
    [Arguments]    ${locator}
    ${text}=    Get Text    ${locator}
    Should Contain    ${text}    Required
    Log     Required validation visible for locator: ${locator}    level=INFO
