# Vale

[![Build Status](https://travis-ci.org/gfax/vale.svg?branch=master)](https://travis-ci.org/gfax/vale)
[![License](https://img.shields.io/badge/License-LGPL%203.0-brightgreen.svg)](LICENSE)

- [Running the game](#running-the-game)
- [Command line arguments](#command-line-arguments)
- [Code testing](#testing)
- [Distributing](#distributing)

## Running the game

1.) Install [LÖVE](https://love2d.org/). `conf.lua` specifies the recommended version of LÖVE to run.

2.) Run the command or create a shortcut.

On unix, you can change to the game directory run it like so:

```sh
love .
```

On Windows, you can create a shortcut with a path to Love and path to the game:

```
"C:/path/to/love.exe" "C:/path/to/game/directory"
```

## Command line arguments

### debug

```
love . debug
```

Run the game in debug mode to draw collision lines and log debug information.



## Code testing

1.) Build docker container

```sh
docker build -t test .
```

2.) Run the container

```
docker run test # Run luacheck to check for linting errors
docker run test busted .
```

...And there you go. It should spit out linting errors and test results.

## Distributing

See the Love [wiki article](https://love2d.org/wiki/Game_Distribution) on creating executable binaries.
