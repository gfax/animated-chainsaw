--- DrawEntity
-- Draw currently-visible entities on screen.

local Args = require 'src/services/args'
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

local system = function(body, sprite, shape)
  if sprite.animation then
    draw_animation(body, sprite)
  else
    draw_quad(body, sprite)
  end

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
