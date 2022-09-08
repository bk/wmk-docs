---
title: "Installation"
slug: installation
weight: 20
---


## Installation

### Method 1: git + pip

Clone this repo into your chosen location (`$myrepo`) and install the necessary
Python modules into a virtual environment:

```shell
cd $myrepo
python3 -m venv venv
. venv/bin/activate
pip install -r requirements.txt
```

After that, either put `$myrepo/bin` into your `$PATH` or create a symlink from
somewhere in your `$PATH` to `$myrepo/bin/wmk`.

Required software (aside from Python, of course):

- `rsync` (for static file copying).
- For `wmk watch` functionality (as well as `watch-serve`), you need either
  `inotifywait` or `fswatch` to be installed and in your `$PATH`. If both are
  available, the former is preferred.

wmk requires a Unix-like environment. In particular, bash must be installed
in `/bin/bash`, and the directory separator is assumed to be `/`.

### Method 2: Homebrew

If you are on MacOS and already have Homebrew, this is the easiest installation
method.

First add the tap to your repositories:

```shell
brew tap bk/wmk
```

Then install wmk from it:

```
brew install --build-from-source wmk
```

### Method 3: Docker

If you are neither on a modern Linux system nor on MacOS with Homebrew, it may
be a better option for you to run wmk via Docker. In that case, after cloning
the repo (or simply copying the `Dockerfile` from it) you can give the command

```shell
docker build -t wmk .
```

in the directory containing the `Dockerfile`, in order to build an image called
`wmk`. You can then run the various wmk subcommands via Docker, for instance

```shell
docker run --rm --volume $(pwd):/data --user $(id -u):$(id -g) wmk b .
```

to build the wmk project in the current directory, or

```shell
docker run --rm -i -t --volume $(pwd):/data --user $(id -u):$(id -g) -p 7007:7007 wmk ws . -i 0.0.0.0
```

to watch for changes in the current directory and run a webserver for the built
files.

Obviously, such commands can be unwieldy, so if you run them regularly you may
want to create aliases or wrappers for them.

