local Sprite = require 'src/services/sprite'

local name = 'fruitstand-keeper'

local entity = {
  body = {
    fixed_rotation = false,
    type = 'dynamic'
  },
  fixture = {
    friction = 0,
    restitution = 2
  },
  shape = {
    height = 32,
    offset_x = 32,
    offset_y = 46,
    width = 32,
    type = 'rectangle'
  },
  sprite = Sprite.list[name],
}

return entity
