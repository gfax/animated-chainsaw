# Vale

[![Build Status](https://travis-ci.org/gfax/vale.svg?branch=master)](https://travis-ci.org/gfax/vale)
[![License](https://img.shields.io/badge/License-LGPL%203.0-brightgreen.svg)](LICENSE)

- [Playing](#playing)
- [Testing](#testing)
- [Distributing](#distributing)

## Playing

1. Install [LÖVE](https://love2d.org/). `conf.lua` specifies a recommended version.

2. Run the command or create a shortcut.

On unix:

```sh
love .
```

On Windows, you can create a shortcut with a path to Love and path to the game:

```
"C:/path/to/love.exe" "C:/path/to/game/directory"
```

## Testing

1. Build docker container

```sh
docker build -t love-experiment .
```

2. Run the container

```
docker run test # Run luacheck to check for linting errors
docker run busted .
```

...And there you go. It should spit out linting errors and test results.

## Distributing

See the Love [wiki article](https://love2d.org/wiki/Game_Distribution) on creating executable binaries.
