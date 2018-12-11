[![Build Status](https://travis-ci.com/tomatoers/tomato.svg?branch=master)](https://travis-ci.com/tomatoers/tomato)

<p align="center">
  <img src="data/icons/128x128/apps/com.github.tomatoers.tomato.png?raw=true" alt="Icon" />
</p>
<h1 align="center">Tomato</h1>
<p align="center">
  <a href="https://appcenter.elementary.io/com.github.tomatoers.tomato"><img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter" /></a>
</p>

![Screenshot](data/screenshots/pomodoro.png?raw=true)

## Keep focused on your work

Tomato is a clean, easy-to-use time manager based on Pomodoro technique. It breaks down work into intervals to keep you focused and allows you to rest during strategic periods to reward your progress. It is a must-have app if you need to avoid procrastination.

## Made for [elementary OS](https://elementary.io)

Tomato is designed and developed on and for [elementary OS](https://elementary.io). Installing via AppCenter ensures instant updates straight from us. Get it on AppCenter for the best experience.

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg?new)](https://appcenter.elementary.io/com.github.tomatoers.tomato)

Versions of Tomato may have been built and made available elsewhere by third-parties. These builds may have modifications or changes and **are not provided nor supported by us**. The only supported version is distributed via AppCenter on elementary OS.

## Developing and Building

If you want to hack on and build Tomato yourself, you'll need the following dependencies:

- gtk3
- granite
- libcanberra
- libunity

Use `meson` to configure the build environment and run `ninja` to build

```shell
meson build --prefix=/usr
ninja -C build
```

To install, use `ninja -C build install`, then execute with `com.github.tomatoers.tomato`

```shell
sudo ninja -C build install
com.github.tomatoers.tomato
```

# Do you want to contribute?

Tomato is open source. You can contribute by reporting/fixing [bugs](https://github.com/tomatoers/tomato/issues) or proposing/implementing new [features](https://github.com/tomatoers/tomato/issues).

Before getting started, read the following guidelines:

- elementary OS [HIG](https://elementary.io/docs/human-interface-guidelines#human-interface-guidelines)
- elementary OS [developer guide](https://elementary.io/docs/code/getting-started#developer-sdk)
