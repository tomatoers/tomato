
# project name
project (com.github.luizaugustomm.tomato)

# the oldest stable cmake version we support
cmake_minimum_required (VERSION 2.8)

# tell cmake where its modules can be found in our project directory
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

set (APP_NAME "Tomato")
set (RELEASE_NAME "Stupice")
set (VERSION "2.0.2")
set (GENERIC_NAME "Pomodoro App")
set (PACKAGE_ID ${CMAKE_PROJECT_NAME})
set (ICON_NAME ${CMAKE_PROJECT_NAME})
set (EXEC_NAME ${CMAKE_PROJECT_NAME})
set (COMMENT "Keep focused on your work")
set (DESCRIPTION "Tomato is a clean, easy-to-use time manager based on Pomodoro technique. It breaks down work into intervals to keep you focused and allows you to rest during strategic periods to reward your progress. It is a must-have app if you need to avoid procrastination.")
set (VERSION_INFO "Release")
set (ENCODING "UTF-8")
set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")

# where we install data directory (if we have any)
include (GNUInstallDirs)
set (CMAKE_INSTALL_PREFIX "/usr")
set (DATADIR ${CMAKE_INSTALL_PREFIX}/share)
set (PKG_DATADIR ${DATADIR}/${CMAKE_PROJECT_NAME})

include(InstallRequiredSystemLibraries)
add_definitions(-w) # Disable gcc warnings

# Add 'make dist' command for creating release tarball
set (CPACK_PACKAGE_VERSION ${VERSION})
set (CPACK_SOURCE_GENERATOR "TGZ")
set (CPACK_SOURCE_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}")
set (CPACK_SOURCE_IGNORE_FILES "/build/;/.bzr/;/.bzrignore;~$;${CPACK_SOURCE_IGNORE_FILES}")

include (CPack)
add_custom_target (dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)

# Add 'make uninstall' command to remove installed files
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)

# we're about to use pkgconfig to make sure dependencies are installed so let's find pkgconfig first
find_package(PkgConfig)

# now let's actually check for the required dependencies
set (DEPS_PACKAGES
    gtk+-3.0
    granite
    libcanberra
    unity
)

pkg_check_modules(DEPS REQUIRED ${DEPS_PACKAGES})

add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

# make sure we have vala
find_package(Vala REQUIRED)
# make sure we use vala
include(ValaVersion)
# make sure it's the desired version of vala
ensure_vala_version("0.22" MINIMUM)

# define variable for sources
set (SOURCE_LIST
    src/Config.vala
    src/Services.vala
    src/Util/Countdown.vala
    src/Util/Timer.vala
    src/Managers/SoundManager.vala
    src/Managers/NotificationManager.vala
    src/Managers/LauncherManager.vala
    src/Managers/WorkManager.vala
    src/Windows/MainWindow.vala
    src/Windows/PreferencesDialog.vala
    src/Widgets/ValueRange.vala
    src/Widgets/Slide.vala
    src/Widgets/Screen.vala
    src/Tomato.vala
)

# Some configuration
configure_file (${CMAKE_CURRENT_SOURCE_DIR}/src/Config.vala.cmake ${CMAKE_CURRENT_SOURCE_DIR}/src/Config.vala)

# files we want to compile
include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
    ${SOURCE_LIST}
PACKAGES
    ${DEPS_PACKAGES}
)

add_executable(${EXEC_NAME} ${VALA_C})

# install the binaries we just made
install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

add_subdirectory (schemas)
add_subdirectory (po)
add_subdirectory(data)

# add translation support
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")

# custom command to update pot template files
set (_pot_file po/${PROJECT_NAME}.pot)
add_custom_command (OUTPUT ${_pot_file}
    COMMAND xgettext --output=${_pot_file} ${SOURCE_LIST} --from-code=${ENCODING}
    DEPENDS ${SOURCE_LIST}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Extract translatable messages to ${_pot_file}")

add_custom_target (pot_file ALL DEPENDS ${_pot_file})

# test data files
include (CTest)
add_test (NAME validate-desktop-file COMMAND desktop-file-validate ${CMAKE_CURRENT_SOURCE_DIR}/data/${PACKAGE_ID}.desktop)
add_test (NAME validate-appdata COMMAND appstreamcli validate ${CMAKE_CURRENT_SOURCE_DIR}/data/${PACKAGE_ID}.appdata.xml)
