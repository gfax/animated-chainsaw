--- DrawEntity
-- Draw currently-visible entities on screen.

local Love = require 'src/services/love'
local System = require 'lib/system'

local components = {
  'body',
  'sprite',
  '?shape'
}

local draw_animation = function(body, sprite)
  sprite.animation:draw(
    sprite.animation,
    body:getX(),
    body:getY(),
    body:getAngle()
  )
end

local draw_quad = function(body, sprite)
  Love.graphics.draw(
    sprite.image,
    sprite.quad,
    body:getX(),
    body:getY(),
    body:getAngle()
  )
end

local system = function(body, sprite)
  if sprite.animation then
    draw_animation(body, sprite)
  else
    draw_quad(body, sprite)
  end

  -- testing
  --if shape then
    --Love.graphics.setColor(160, 72, 14, 255)
    --Love.graphics.polygon(
      --'fill',
      --body:getWorldPoints(shape:getPoints())
    --)
  --end
end

return System(components, system)
