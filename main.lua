--- This is the main Love file, containing all the pieces of the game loop.

-- Load world before anything else.
local World = require 'src/services/world'

-- Libs

-- Services
local Love = require 'src/services/love'
local Background = require 'src/services/background'
local Entity = require 'src/services/entity'

-- Systems
local DrawBackground = require 'src/systems/draw-background'
local DrawEntity = require 'src/systems/draw-entity'
local LoadBackground = require 'src/systems/load-background'
local UpdateEntityAnimation = require 'src/systems/update-entity-animation'
--local UpdatePlayerVelocity = require 'src/systems/update-player-velocity'

-- Functions to initialize on game boot
function Love.load()
  LoadBackground(Background.list)
end

-- Functions to run on re-draw
function Love.draw()
  DrawBackground(Background.list)
  DrawEntity(Entity.list)
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
function Love.update(dt)
  UpdateEntityAnimation(Entity.list, dt)
  --UpdatePlayerVelocity(Entity.list)
  World:update(dt)
end
