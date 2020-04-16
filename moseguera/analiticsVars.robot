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


*** Test Cases ***
Read variables from urls
    [Teardown]             Close Browser
    @{vars}=  Read File    ${VARS_FILE}
    @{urls}=  Read File    ${URLS_FILE}
    Should Not Be Empty    @{vars}
    Should Not Be Empty    @{urls}
    Open Browser           ${START_URL}     ${BROWSER}
    #Press Keys             None             F12
    Urls Loop              ${urls}          ${vars}
    Log File               ${RESULTS_FILE}


*** Keywords ***
Urls Loop
    [Arguments]     ${urls}     ${vars}
    Remove File     ${RESULT_FILE}
    :FOR    ${url}  IN  @{urls}
    \  Go To            ${url}
    \  Append To File   ${RESULT_FILE}      ${url}\n
    \  Vars Loop        ${url}  @{vars}

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

    ${value}        Execute Java Script     ${variable}