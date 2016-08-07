local Love = require 'src/services/love'
local Sprite = require 'src/services/sprite'
local World = require 'src/services/world'

local name = 'protagonist'

local body = Love.physics.newBody(World, 0, 0, 'dynamic')
body:setFixedRotation(true)

local shape = Love.physics.newPolygonShape(
  12, 4,
  20, 4,
  24, 16,
  20, 28,
  12, 28,
  8, 16
)

local fixture = Love.physics.newFixture(body, shape)

local entity = {
  acceleration = 140,
  body = body,
  fixture = fixture,
  input_direction = {
    down = false,
    left = false,
    right = false,
    up = false
  },
  max_speed = 100,
  player_id = 1,
  shape = shape,
  sprite = Sprite.list[name],
}

return entity
