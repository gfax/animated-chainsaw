--- Libs

--- Services
local Love = require 'src/services/love'
local Background = require 'src/services/background'

-- Systems
local DrawBackground = require 'src/systems/draw-background'
local LoadBackground = require 'src/systems/load-background'

-- Functions to initialize on game boot
function Love.load()
  LoadBackground(Background.list)
end

-- Functions to run on re-draw
function Love.draw()
  DrawBackground(Background.list)
end

-- All active callbacks for pressing a key
-- pressedKey (string)
function Love.keypressed()
end

-- All active callbacks for releasing a key
-- releasedKey (string)
function Love.keyreleased()
end

-- Calculations to re-run on going through another loop
-- dt (integer) delta time (in seconds)
function Love.update()
end
