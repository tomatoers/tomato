
# project name
project (tomato)

# the oldest stable cmake version we support
cmake_minimum_required (VERSION 2.6)

# tell cmake where its modules can be found in our project directory
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

set (GETTEXT_PACKAGE ${CMAKE_PROJECT_NAME})
set (EXEC_NAME ${CMAKE_PROJECT_NAME})
set (ICON_NAME ${CMAKE_PROJECT_NAME})
set (APP_NAME "Tomato")
set (GENERIC_NAME "Pomodoro App")
set (RELEASE_NAME "Amai")
set (PACKAGE_ID "com.github.luizaugustomm.tomato")
set (COMMENT "Keep focused on your work")
set (VERSION "1.2.5")
set (VERSION_INFO "Stable release")

# where we install data directory (if we have any)
include (GNUInstallDirs)
set (CMAKE_INSTALL_PREFIX "/usr")
set (DATADIR ${CMAKE_INSTALL_PREFIX}/share)
# set (DATADIR ${CMAKE_INSTALL_FULL_DATADIR})
set (PKG_DATADIR ${DATADIR}/${CMAKE_PROJECT_NAME})
set (DOLLAR "$")
set (ENCODING "UTF-8")

# Add 'make dist' command for creating release tarball
set (CPACK_PACKAGE_VERSION ${VERSION})
set (CPACK_SOURCE_GENERATOR "TGZ")
set (CPACK_SOURCE_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}")
set (CPACK_SOURCE_IGNORE_FILES "/build/;/.bzr/;/.bzrignore;~$;${CPACK_SOURCE_IGNORE_FILES}")

include (CPack)
add_custom_target (dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)

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
configure_file (${CMAKE_CURRENT_SOURCE_DIR}/data/${PACKAGE_ID}.desktop.in ${CMAKE_CURRENT_SOURCE_DIR}/data/${PACKAGE_ID}.desktop)

# Some definitions
add_definitions(-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")

# custom command to update pot template files
set (_pot_file po/${PROJECT_NAME}.pot)
add_custom_command (OUTPUT ${_pot_file}
    COMMAND xgettext --output=${_pot_file} ${SOURCE_LIST} --from-code=${ENCODING}
    DEPENDS ${SOURCE_LIST}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Extract translatable messages to ${_pot_file}")

add_custom_target (pot_file ALL DEPENDS ${_pot_file})

include(InstallRequiredSystemLibraries)

# we're about to use pkgconfig to make sure dependencies are installed so let's find pkgconfig first
find_package(PkgConfig)

# now let's actually check for the required dependencies
pkg_check_modules(DEPS REQUIRED
    gtk+-3.0
    granite
    libcanberra
    unity
)

set(NORMAL_CFLAGS ${DEPS_CFLAGS} ${LIBSOURCE_CFLAGS} ${GCONF_CFLAGS})
set(NORMAL_LINK_DIRS ${DEPS_LIBRARY_DIRS} ${LIBSOURCE_LIBRARY_DIRS} ${GCONF_LIBRARY_DIRS})
set(NORMAL_LIBRARIES ${DEPS_LIBRARIES} ${LIBSOURCE_LIBRARIES} ${GCONF_LIBRARIES})

add_definitions (${DEPS_CFLAGS} ${LIBSOURCE_CFLAGS} ${GCONF_CFLAGS})
link_libraries (${DEPS_LIBRARIES} ${LIBSOURCE_LIBRARIES} ${GCONF_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS} ${LIBSOURCE_LIBRARY_DIRS} ${GCONF_LIBRARY_DIRS})

# make sure we have vala
find_package(Vala REQUIRED)
# make sure we use vala
include(ValaVersion)
# make sure it's the desired version of vala
ensure_vala_version("0.16" MINIMUM)

add_definitions(-w) # Disable gcc warnings

# files we want to compile
include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
    ${SOURCE_LIST}

# tell what libraries to use when compiling
PACKAGES
    gtk+-3.0
    granite
    libcanberra
    unity
)

# tell cmake what to call the executable we just made
add_executable(${EXEC_NAME} ${VALA_C})

# install the binaries we just made
install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

include_directories(${CMAKE_BINARY_DIR}/src)

add_subdirectory (schemas)
add_subdirectory (po)

# install our .desktop file so the Applications menu will see it
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/${PACKAGE_ID}.desktop DESTINATION ${DATADIR}/applications)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/style/window.css DESTINATION ${PKG_DATADIR}/style)
install (DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/ DESTINATION ${DATADIR}/icons/hicolor)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/tomato.svg DESTINATION ${DATADIR}/pixmaps)

# uninstall target
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
