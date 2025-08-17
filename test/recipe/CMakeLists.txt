
add_executable(
    test_recipe

    test_recipe.cpp
)

target_link_libraries(
    test_recipe

    # Internal libraries:
    opentodolist-common

    # Qt Libraries
    Qt::Test
)

add_test(
    NAME recipe
    COMMAND $<TARGET_FILE:test_recipe> -platform minimal
)
