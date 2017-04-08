# What is Tomato?

_Tomato_ is a pomodoro app designed for elementaryOS. It is simple, usable and efficient.

# How to install Tomato on elementaryOS?

Look for it on AppCenter!

# How to install Tomato on Ubuntu?

I must have in mind that Tomato is exclusively designed for elementaryOS. But if you want to install Tomato on Ubuntu, you can add the official PPA.
```
$ sudo apt-add-repository ppa:tomato-team/tomato-stable
$ sudo apt-get update
$ sudo apt-get install tomato
```

# How to build Tomato?

First of all, you need to install the following dependencies:
- gtk3
- granite
- libcanberra

Use the command bellow to install the dependencies
```
$ sudo apt install elementary-sdk libcanberra-dev
```

Clone this repository
```
$ git clone https://github.com/luizaugustomm/tomato.git
```

Go to the project's root folder and create a new one called _build_
```
$ cd tomato
$ mkdir build
$ cd build
```

Finally, build and install the app
```
$ make
$ sudo make install
```

# Do you want to contribute?

Tomato is open-source. You can contribute [translating](https://translations.launchpad.net/tomatoapp) it, reporting/fixing [bugs](https://github.com/luizaugustomm/tomato/issues) or proposing/implementing new [features](https://github.com/luizaugustomm/tomato/issues).

Before getting started, read the following guidelines:

- elementaryOS [HIG](https://elementary.io/docs/human-interface-guidelines#human-interface-guidelines)
- elementaryOS [developer guide](https://elementary.io/docs/code/getting-started#developer-sdk)
