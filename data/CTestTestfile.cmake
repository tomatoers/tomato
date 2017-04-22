# CMake generated Testfile for 
# Source directory: /home/lamm/Projetos/tomato
# Build directory: /home/lamm/Projetos/tomato/data
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(validate-desktop-file "desktop-file-validate" "/home/lamm/Projetos/tomato/data/com.github.luizaugustomm.tomato.desktop")
add_test(validate-appdata "appstreamcli" "validate" "/home/lamm/Projetos/tomato/data/com.github.luizaugustomm.tomato.appdata.xml")
subdirs(schemas)
subdirs(po)
