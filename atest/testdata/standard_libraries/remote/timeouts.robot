*** Settings ***
Library           DateTime

*** Variables ***
${PORT}           8270
${SUPPORTED}      sys.version_info >= (2, 6) and sys.platform != 'cli'

*** Test Cases ***
Initial connection failure
    Run Keyword If    ${SUPPORTED}
    ...    Test initial connection failure
    ...    ELSE
    ...    Timeouts are not supported on Python 2.5

Too long keyword execution time
    Run Keyword If    ${SUPPORTED}
    ...    Test too long keyword execution time

*** Keywords ***
Test initial connection failure
    # Would be better to test the actual error, but it depends on network
    # configuation etc.
    ${error} =    Catenate
    ...    Calling dynamic method 'get_keyword_names' failed:
    ...    Connecting remote server at http://1.2.3.4:666 failed: *
    ${start} =    Get Current Date
    Run Keyword And Expect Error    ${error}
    ...    Import Library    Remote    1.2.3.4:666    timeout=0.2 seconds
    ${end} =    Get Current Date
    ${elapsed} =    Subtract Date From Date    ${end}    ${start}
    Should Be True    ${elapsed} < 2

Test too long keyword execution time
    Import Library           Remote    http://127.0.0.1:${PORT}     ${0.3}
    Run Keyword And Expect Error
    ...    Connection to remote server broken: timed out
    ...    Remote.Sleep    2

Timeouts are not supported on Python 2.5
    Run Keyword And Expect Error
    ...    *This Python version does not support timeouts.*
    ...    Import Library    Remote    10.82.70.0:666    timeout=0.2 seconds
