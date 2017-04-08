echo "Creating icons..."
echo "16x16"
inkscape -C --export-png=icons/16x16/apps/tomato.png --export-height=16 --export-width=16 --export-background-opacity=0 --without-gui tomato.svg
echo "22x22"
inkscape -C --export-png=icons/22x22/apps/tomato.png --export-height=22 --export-width=22 --export-background-opacity=0 --without-gui tomato.svg
echo "24x24"
inkscape -C --export-png=icons/24x24/apps/tomato.png --export-height=24 --export-width=24 --export-background-opacity=0 --without-gui tomato.svg
echo "32x32"
inkscape -C --export-png=icons/32x32/apps/tomato.png --export-height=32 --export-width=32 --export-background-opacity=0 --without-gui tomato.svg
echo "48x48"
inkscape -C --export-png=icons/48x48/apps/tomato.png --export-height=48 --export-width=48 --export-background-opacity=0 --without-gui tomato.svg
echo "64x64"
inkscape -C --export-png=icons/64x64/apps/tomato.png --export-height=64 --export-width=64 --export-background-opacity=0 --without-gui tomato.svg
echo "128x128"
inkscape -C --export-png=icons/128x128/apps/tomato.png --export-height=128 --export-width=128 --export-background-opacity=0 --without-gui tomato.svg
echo "256x562"
inkscape -C --export-png=icons/256x256/apps/tomato.png --export-height=256 --export-width=256 --export-background-opacity=0 --without-gui tomato.svg
echo "Moving tomato.svg to scalable directory"
cp tomato.svg icons/scalable/apps/
