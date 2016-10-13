--- This is the main Love file, containing all the pieces of the game loop.

-- Services
local Args = require 'src/services/args'
local Camera = require 'src/services/camera'
local Entity = require 'src/services/entity'
local Input = require 'src/services/input'
local Love = require 'src/services/love'
local Map = require 'src/services/map'
local World = require 'src/services/world'

-- Systems
local DrawEntity = require 'src/systems/draw-entity'
local UpdateCamera = require 'src/systems/update-camera'
local UpdateEntityAnimation = require 'src/systems/update-entity-animation'
local UpdatePlayerVelocity = require 'src/systems/update-player-velocity'

-- Functions to initialize on game boot
function Love.load(args)
  Args.load(args)
  Map.load('general')
  -- Press esc to close game
  Input.register_key_press('escape', function()
    Love.event.quit()
  end)
end

-- Functions to run on re-draw
function Love.draw()
  Camera.set()
  Map.draw()
  for _, entity in ipairs(Entity.list) do
    DrawEntity(entity)
  end
  Camera.unset()
end

-- All active callbacks for pressing a key
-- pressedKey (string)
function Love.keypressed(pressed_key)
  Input.call_key_press(pressed_key)
end

-- All active callbacks for releasing a key
-- releasedKey (string)
function Love.keyreleased(released_key)
  Input.call_key_release(released_key)
end

-- Calculations to re-run on going through another loop
-- dt (integer) delta time (in seconds)
function Love.update(dt)
  for _, entity in ipairs(Entity.list) do
    UpdateCamera(entity)
    UpdateEntityAnimation(entity, dt)
    UpdatePlayerVelocity(entity)
  end
  World:update(dt)
end
