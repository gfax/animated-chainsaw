--- DrawEntity
-- Draw currently-visible entities on screen.

local Args = require 'src/services/args'
local Love = require 'src/services/love'
local System = require 'lib/system'

local components = {
  'body',
  'sprites',
  '?current_action',
  '?shape',
}

local system = function(body, sprites, current_action, shape)
  local sprite_key = current_action or 'default'
  sprites.actions[sprite_key]:draw(
    sprites.image,
    body:getX(),
    body:getY(),
    body:getAngle()
  )

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
