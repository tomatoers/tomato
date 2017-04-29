include (Translations)

configure_file (${CMAKE_CURRENT_SOURCE_DIR}/${PACKAGE_ID}.desktop.in.in ${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_ID}.desktop.in)
configure_file_translation(${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_ID}.desktop.in ${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_ID}.desktop ${CMAKE_SOURCE_DIR}/po/)

configure_file (${CMAKE_CURRENT_SOURCE_DIR}/${PACKAGE_ID}.appdata.xml.in.in ${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_ID}.appdata.xml.in)
configure_file_translation(${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_ID}.appdata.xml.in ${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_ID}.appdata.xml ${CMAKE_SOURCE_DIR}/po/)

# install our .desktop file so the Applications menu will see it
install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_ID}.appdata.xml DESTINATION ${DATADIR}/metainfo/)
install (FILES ${CMAKE_CURRENT_BINARY_DIR}/${PACKAGE_ID}.desktop DESTINATION ${DATADIR}/applications)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/style/window.css DESTINATION ${PKG_DATADIR}/style)
install (DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/icons/ DESTINATION ${DATADIR}/icons/hicolor)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/icons/scalable/apps/${ICON_NAME}.svg DESTINATION ${DATADIR}/pixmaps)
