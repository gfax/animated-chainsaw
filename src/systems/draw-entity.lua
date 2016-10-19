--- DrawEntity
-- Draw currently-visible entities on screen.

local Args = require 'src/services/args'
local Love = require 'src/services/love'
local System = require 'lib/system'

local components = {
  'current_action',
  'body',
  'fixture',
  'sprites',
  '?shape',
}

local system = function(current_action, body, fixture, sprites, shape, layer_idx)
  -- Don't draw the entity unless it belongs to the
  -- layer from which this system was invoked.
  if fixture:getGroupIndex() ~= layer_idx then
    return
  end
  local sprite_key = current_action
  sprites.actions[sprite_key]:draw(
    sprites.image,
    body:getX(),
    body:getY(),
    body:getAngle()
  )

  -- Draw fixture shape edges in debug mode
  if Args.get_arg('debug') and shape then
    Love.graphics.setColor(160, 72, 14, 255)
    Love.graphics.polygon(
      'line',
      body:getWorldPoints(shape:getPoints())
    )
    Love.graphics.setColor(255, 255, 255, 255)
  end
end

return System(components, system)
