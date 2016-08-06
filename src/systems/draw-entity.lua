--- DrawEntity
-- Draw currently-visible entities on screen.

local Love = require 'src/services/love'
local System = require 'lib/system'

local components = {
  'body',
  'shape',
  '?animation',
  '?polygon',
  '?sprite'
}

local system = function(body, shape, animation, polygon, sprite)
  if animation then
    --animation:draw(entity.sprite, entity.position.x, entity.position.y)
    animation:draw(
      sprite,
      body:getX(),
      body:getY(),
      body:getAngle()
    )
    Love.graphics.setColor(160, 72, 14, 255)
    Love.graphics.polygon(
      'fill',
      body:getWorldPoints(shape:getPoints())
    )
  elseif polygon then
    Love.graphics.setColor(72, 160, 14, 255)
    Love.graphics.polygon(
      'fill',
      body:getWorldPoints(shape:getPoints())
    )
  elseif sprite then
    Love.graphics.draw(
      sprite,
      body:getX(),
      body:getY(),
      body:getAngle()
    )
  end
end

return System(components, system)
