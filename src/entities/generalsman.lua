local Love = require 'src/services/love'
local Sprite = require 'src/services/sprite'
local World = require 'src/services/world'

local name = 'generalsman'

local body = Love.physics.newBody(World, 768, 576, 'dynamic')
body:setFixedRotation(false)

local shape = Love.physics.newRectangleShape(32, 46, 32, 32)

local fixture = Love.physics.newFixture(body, shape)
fixture:setFriction(0)
fixture:setRestitution(2)

local entity = {
  body = body,
  fixture = fixture,
  shape = shape,
  sprite = Sprite.list[name],
}

return entity
