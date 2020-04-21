*** Settings ***
Documentation       Helper suite to validate anaylitics variables
Library             SeleniumLibrary
Library             OperatingSystem
Library             String


*** Variables ***
${BROWSER}           chrome
${VARS_FILE}         vars.csv
${URLS_FILE}         urls.csv
${RESULT_FILE}       result.csv
${START_URL}         about:blank
${ERROR_VALUE}       Error
${PASS}              PASS
${WAIT_CONDITION}    return document.readyState == "complete"


*** Test Cases ***
Read variables from urls
    [Teardown]             Close Browser
    @{vars}=  Read File    ${VARS_FILE}
    @{urls}=  Read File    ${URLS_FILE}
    Should Not Be Empty    @{vars}
    Should Not Be Empty    @{urls}
    Open Browser           ${START_URL}     ${BROWSER}
    Urls Loop              ${urls}          ${vars}
    Log File               ${RESULT_FILE}


*** Keywords ***
Urls Loop
    [Arguments]     ${urls}     ${vars}
    Remove File     ${RESULT_FILE}
    :FOR    ${url}  IN       @{urls}
    \  Go To                 ${url}
    \  ${status}             ${return}=                     Run Keyword And Ignore Error     Wait For Condition   ${WAIT_CONDITION}
    \  Continue For Loop If  "${status}" != "${PASS}"
    \  Append To File        ${RESULT_FILE}      ${url}\n
    \  Vars Loop             ${url}  @{vars}

Vars Loop
    [Arguments]     ${url}  @{vars}

    :FOR    ${var}  IN  @{vars}
    \   ${value} =      Read variable    ${var}
    \   Append To File  ${RESULT_FILE}   ,${var},${value}\n


Read File
    [Arguments]     ${file}
    [Return]        @{content}

    ${file_str} =   Get File        ${file}
    @{content} =    Split String    ${file_str}


Read variable
    [Arguments]     ${variable}
    [Return]        ${value}

    ${status}   ${value} =      Run Keyword And Ignore Error    Execute Java Script     return ${variable}
    ${error}=   Run Keyword If  "${status}" != "${PASS}"        Get Line                ${value}            0
    Return From Keyword If      "${status}" != "${PASS}"        ${ERROR_VALUE},${error}