icon_sizes = ['16', '22', '24', '32', '48', '64', '128', '256']

foreach i : icon_sizes
  install_data (
    join_paths ('icons', i + 'x' + i, 'apps', meson.project_name () + '.png'),
    install_dir: join_paths (get_option ('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
  )
endforeach

install_data (
  join_paths ('icons', 'scalable', 'apps', meson.project_name () + '.svg'),
  install_dir: join_paths (get_option ('datadir'), 'icons', 'hicolor', 'scalable', 'apps')
)

appdata = configure_file (
    input: meson.project_name () + '.appdata.xml.in',
    output: meson.project_name () + '.appdata.xml.in',
    configuration: config
)

desktop = configure_file(
    input: meson.project_name () + '.desktop.in',
    output: meson.project_name () + '.desktop.in',
    configuration: config
)

i18n.merge_file (
    'desktop',
    input: desktop,
    output: meson.project_name () + '.desktop',
    install: true,
    install_dir: join_paths (get_option ('datadir'), 'applications'),
    po_dir: join_paths (meson.source_root (), 'po'),
    type: 'desktop'
)

i18n.merge_file (
    'appdata',
    input: appdata,
    output: meson.project_name () + '.appdata.xml',
    install: true,
    install_dir: join_paths (get_option ('datadir'), 'metainfo'),
    po_dir: join_paths (meson.source_root (), 'po')
)

install_data (
    join_paths ('style', 'window.css'),
    install_dir: join_paths (pkg_datadir, 'style')
)

install_data (
    meson.project_name () + '.gschema.xml',
    install_dir : join_paths (get_option ('datadir'), 'glib-2.0', 'schemas')
)

dvf = find_program ('desktop-file-validate', required: false)
asc = find_program ('appstreamcli', required: false)
vala_lint = find_program ('io.elementary.vala-lint', required: false)

if dvf.found ()
test (
    'Validate desktop file',
    dvf,
    args: join_paths (meson.current_build_dir (), meson.project_name () + '.desktop')
)
endif


if asc.found ()
test (
   'Validate appdata file',
    asc,
    args: ['validate', join_paths (meson.current_build_dir (), meson.project_name () + '.appdata.xml')]
)
endif


if vala_lint.found ()
  test (
    'Validate Vala code style',
    vala_lint,
    args: ['-d', join_paths (meson.source_root (), 'src')]
  )
endif