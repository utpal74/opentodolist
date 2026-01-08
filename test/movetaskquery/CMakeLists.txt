
add_executable(
    test_movetaskquery

    test_movetaskquery.cpp
)

target_link_libraries(
    test_movetaskquery

    # Internal libraries:
    opentodolist-common

    # Qt Libraries
    Qt::Test
)

add_test(
    NAME movetaskquery
    COMMAND $<TARGET_FILE:test_movetaskquery> -platform minimal
)
