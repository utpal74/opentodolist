cmake_minimum_required(VERSION 3.16.3)

# Generate build commands JSON file:
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# To avoid linker warnings building for iOS
set(CMAKE_CXX_VISIBILITY_PRESET hidden)

# Set policies explicitly:
# cmake_policy(SET CMP0114 NEW) # Use independent step targets w/ external project on Xcode new build system.

project(OpenTodoList)


# Include modules:
include(cmake/options.cmake)
include(cmake/global-variables.cmake)
include(cmake/version.cmake)
include(cmake/Flatpak.cmake)
include(3rdparty/android-openssl/android_openssl.cmake)

# Enable unit tests:
enable_testing()

if(NOT OPENTODOLIST_QT_VERSIONS)
    # If OPENTODOLIST_QT_VERSIONS is not set by user, look for Qt6:
    set(OPENTODOLIST_QT_VERSIONS Qt6)
    set(QT_VERSION_MAJOR 6)
endif()

set(REQUIRED_QT_COMPONENTS Core Quick Qml Xml Concurrent Sql RemoteObjects LinguistTools Widgets Network NetworkAuth Test)

find_package(
    Qt6
    COMPONENTS
        ${REQUIRED_QT_COMPONENTS}
    REQUIRED
)

qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

qt_standard_project_setup(REQUIRES 6.8)

# Convenience: Set the QT_INSTALL_PREFIX based on QT_DIR (which is set by the first find_package
# call above. The QT_DIR is set to something like
# <prefix>/lib/cmake/Qt6, so we have to get the directory 3 times.
if(NOT QT_INSTALL_PREFIX)
    get_filename_component(QT_INSTALL_PREFIX ${Qt${QT_VERSION_MAJOR}_DIR} DIRECTORY)
    get_filename_component(QT_INSTALL_PREFIX ${QT_INSTALL_PREFIX} DIRECTORY)
    get_filename_component(QT_INSTALL_PREFIX ${QT_INSTALL_PREFIX} DIRECTORY)
    if(QT_INSTALL_PREFIX STREQUAL "/")
      set(QT_INSTALL_PREFIX "")
    endif()
endif()

# Convenience: Set a path to a host Qt installation (for cross compiling). This is needed when
# we cross-compile as we have to build some tools for the host.
if(NOT QT_HOST_INSTALL_PREFIX)
    set(QT_HOST_INSTALL_PREFIX ${QT_INSTALL_PREFIX})
    if(ANDROID OR IOS)
        # Check if this is a Qt installation made with the official installer
        get_filename_component(_version_dir ${QT_INSTALL_PREFIX} DIRECTORY)
        get_filename_component(_root_dir ${_version_dir} DIRECTORY)
        if(EXISTS ${_root_dir}/MaintenanceTool.dat)
            if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin")
                set(QT_HOST_INSTALL_PREFIX ${_version_dir}/macos)
            elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
                set(QT_HOST_INSTALL_PREFIX ${_version_dir}/gcc_64)
            elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
                message("TODO: Implement auto-detection of Qt host tools on Windows")
            endif()
        endif()
        unset(_version_dir)
        unset(_root_dir)
    endif()
endif()

# For KDE packages: Used when cross compiling
if(NOT KF5_HOST_TOOLING)
    set(KF5_HOST_TOOLING ${QT_HOST_INSTALL_PREFIX})
endif()


if(OPENTODOLIST_WITH_KNOTIFICATIONS)
    find_package(KF5Notifications REQUIRED)
endif()

if(OPENTODOLIST_USE_SYSTEM_KF_SYNTAX_HIGHLIGHTING)
    find_package(KF5SyntaxHighlighting REQUIRED)
endif()

if(NOT ANDROID AND OPENTODOLIST_USE_SYSTEM_QTKEYCHAIN)
    find_package(Qt${QT_VERSION_MAJOR}Keychain REQUIRED)
endif()

if(OPENTODOLIST_USE_SYSTEM_QLMDB)
    find_package(QLMDB-qt${QT_VERSION_MAJOR} REQUIRED)
endif()

if(OPENTODOLIST_USE_SYSTEM_SYNQCLIENT)
    find_package(SynqClient-qt${QT_VERSION_MAJOR} REQUIRED)
endif()

# Build using static libraries:
set(BUILD_SHARED_LIBS OFF)

# Install data files:
set(APPLICATION_NAME OpenTodoList)
set(APPLICATION_EXECUTABLE OpenTodoList)
set(APPLICATION_ICON_NAME net.rpdev.OpenTodoList)
configure_file(
    net.rpdev.OpenTodoList.desktop.in
    ${CMAKE_CURRENT_BINARY_DIR}/net.rpdev.OpenTodoList.desktop
)
include(GNUInstallDirs)
install(
    DIRECTORY app/icons/hicolor
    DESTINATION ${CMAKE_INSTALL_DATADIR}/icons/
)
install(
    FILES net.rpdev.OpenTodoList.metainfo.xml
    DESTINATION ${CMAKE_INSTALL_DATADIR}/metainfo
)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/net.rpdev.OpenTodoList.desktop
    DESTINATION ${CMAKE_INSTALL_DATADIR}/applications
)


# Include sub-directories:
add_subdirectory(3rdparty)
add_subdirectory(src)
if(NOT IOS AND NOT ANDROID)
    add_subdirectory(test)
endif()


# Show other, project-related files:
file(GLOB_RECURSE
    OTHER_FILES
        OpenTodoList.desktop.in
        README.md
        COPYING
        Doxyfile
        net.rpdev.OpenTodoList.json
        net.rpdev.OpenTodoList.metainfo.xml
        snapcraft.yaml
        doc/*
        .gitlab-ci.yml
        bin/*
        templates/*
        ci/*
        cmake/*
        app/android/*
        lib/*
        test/*
)
add_custom_target(OtherFiles SOURCES ${OTHER_FILES})

# Add a custom target which runs qmllint first and then out
# CMake script which will read the JSON output and print it formatted
# lile GCC/Clang warning messages. This way, tools like VSCode will properly
# pick these up:
add_custom_target(
    qmllint
    DEPENDS
        all_qmllint_json
    COMMAND
        ${CMAKE_COMMAND}
            -DJSON_FILE=${CMAKE_CURRENT_BINARY_DIR}/OpenTodoList_qmllint.json
            -P ${CMAKE_SOURCE_DIR}/bin/qmllintjson2compilerwarnings.cmake
)