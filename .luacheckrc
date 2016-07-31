-- -*- mode: lua; -*- vim: set syntax=lua:

-- Base globals, 'min' is the intersection of globals
-- common between Lua 5.1, Lua 5.2 and LuaJIT 2.0.
std = 'min'

-- Ignore libs as we aren't accountable for those
exclude_files = { 'lib/*.*' }

-- Ignore non-standard lua love behavior just right here
files['src/services/love.lua'] = { globals = { 'love' } }

-- List of allowed globals
globals = {}

-- false, don't allow something to be defined (??)
allow_defined = false

-- false, don't allow something to be defined on top (??)
allow_defined_top = false

-- true, enable color on command line
color = true

-- true, enable error codes on command line
-- http://luacheck.readthedocs.org/en/stable/warnings.html
codes = true

-- true, don't allow globals
global = true

-- true, don't allow variables to be shadowed
redefined = true

-- true, don't allow use of the deprecated module function
module = true

-- true, don't allow unused variable
unused = true

-- true, don't allow unused arguments
unused_args = true

-- true, don't allow unused secondary variables
unused_secondaries = true
