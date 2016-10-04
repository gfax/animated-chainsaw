local Love = require 'src/services/love'
local Sprite = require 'src/services/sprite'
local World = require 'src/services/world'

local name = 'protagonist'

local body = Love.physics.newBody(World, 0, 0, 'dynamic')
body:setFixedRotation(true)

local shape = Love.physics.newRectangleShape(32, 46, 32, 32)

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
