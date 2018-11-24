project(
  'com.github.tomatoers.tomato', 'vala', 'c',
  version : '2.0.2',
  license : 'GPL2+'
)

add_global_arguments (
  '-DGETTEXT_PACKAGE="' + meson.project_name () + '"',
  language: 'c'
)


prefix = get_option ('prefix')
datadir = join_paths (prefix, get_option ('datadir'))
pkg_datadir = join_paths (datadir, meson.project_name ())

config = configuration_data ()
config.set ('APP_NAME', 'Tomato')
config.set ('RELEASE_NAME', 'Stupice')
config.set ('VERSION', meson.project_version ())
config.set ('GENERIC_NAME', 'Pomodoro App')
config.set ('PACKAGE_ID', meson.project_name ())
config.set ('ICON_NAME', meson.project_name ())
config.set ('EXEC_NAME', meson.project_name ())
config.set ('COMMENT', 'Keep focused on your work')
config.set ('DESCRIPTION', 'Tomato is a clean, easy-to-use time manager based on Pomodoro technique. It breaks down work into intervals to keep you focused and allows you to rest during strategic periods to reward your progress. It is a must-have app if you need to avoid procrastination.')
config.set ('VERSION_INFO', 'Release')
config.set ('ENCODING', 'UTF-8')
config.set ('GETTEXT_PACKAGE', meson.project_name ())
config.set ('PREFIX', prefix)
config.set ('DATADIR', datadir)
config.set ('PKG_DATADIR', pkg_datadir)

build_config = configure_file (
  input: 'src/Config.vala.in',
  output: 'Config.vala',
  configuration: config
)

dependencies = [
  dependency ('gtk+-3.0', version: '>=3.14'),
  dependency ('granite', version: '>=0.4.0'),
  dependency ('libcanberra'),
  dependency ('unity')
]

main = executable (
  meson.project_name (),
  'src/Services.vala',
  'src/Util/Countdown.vala',
  'src/Util/Timer.vala',
  'src/Managers/SoundManager.vala',
  'src/Managers/NotificationManager.vala',
  'src/Managers/LauncherManager.vala',
  'src/Managers/WorkManager.vala',
  'src/Windows/MainWindow.vala',
  'src/Windows/PreferencesDialog.vala',
  'src/Widgets/ValueRange.vala',
  'src/Widgets/Slide.vala',
  'src/Widgets/Screen.vala',
  'src/Tomato.vala',
  build_config,
  dependencies: dependencies,
  install: true
)

subdir ('po')
subdir ('data')

meson.add_install_script ('post_install.py')