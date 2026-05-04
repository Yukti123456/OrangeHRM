*** Settings ***
Library             SeleniumLibrary
Library             OperatingSystem
Library             Collections

Suite Setup          Open Browser And Navigate To Login Page
Suite Teardown      Close All Browsers
Test Setup          Navigate To Login Page
Test Teardown       Capture Screenshot On Failure
Resource            /Resources/Keywords.robot

*** Test Cases ***

#  TC-01  Valid Login

TC-01 Valid Login With Correct Username And Password
    [Documentation]    Verifies that a user with correct credentials is taken to the Dashboard.
    [Tags]    smoke    positive    login
    Fill Login Form    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Wait For Dashboard
    Element Should Be Visible    ${DASHBOARD_HEADER}
    Log    Successfully logged in as ${VALID_USERNAME}    level=INFO
    [Teardown]    Run Keywords     Logout If Logged In    AND    Capture Screenshot On Failure

#  TC-02  Wrong Username, Correct Password


TC-02 Login With Wrong Username And Correct Password
    [Documentation]    Verifies that an incorrect username with a valid password shows an error.
    [Tags]    negative    invalid-username    login
    Fill Login Form    ${WRONG_USERNAME}    ${VALID_PASSWORD}
    Wait For Error Message
    Error Message Should Be    Invalid credentials

#  TC-03  Correct Username, Wrong Password


TC-03 Login With Correct Username And Wrong Password
    [Documentation]    Verifies that a valid username with the wrong password shows an error.
    [Tags]    negative    invalid-password    login
    Fill Login Form    ${VALID_USERNAME}    ${WRONG_PASSWORD}
    Wait For Error Message
    Error Message Should Be    Invalid credentials

#  TC-04  Both Wrong Credentials

TC-04 Login With Both Wrong Username And Password
    [Documentation]    Verifies that completely wrong credentials produce an error.
    [Tags]    negative    invalid-credentials    login
    Fill Login Form    ${WRONG_USERNAME}    ${WRONG_PASSWORD}
    Wait For Error Message
    Error Message Should Be    Invalid credentials

#  TC-05  Empty Username

TC-05 Login With Empty Username Field
    [Documentation]    Verifies that submitting with an empty username shows "Required".
    [Tags]    negative    empty-field    validation
    Fill Login Form    ${EMPTY_STRING}    ${VALID_PASSWORD}
    Wait For Required Field Error    ${USERNAME_REQUIRED}
    Field Error Should Say Required    ${USERNAME_REQUIRED}

#  TC-06  Empty Password

TC-06 Login With Empty Password Field
    [Documentation]    Verifies that submitting with an empty password shows "Required".
    [Tags]    negative    empty-field    validation
    Fill Login Form    ${VALID_USERNAME}    ${EMPTY_STRING}
    Wait For Required Field Error    ${PASSWORD_REQUIRED}
    Field Error Should Say Required    ${PASSWORD_REQUIRED}
