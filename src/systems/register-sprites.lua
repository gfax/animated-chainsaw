--- RegisterSprites
-- Load graphics for spawning sprites

local System = require 'lib/system'

local Anim8 = require 'lib/anim8'
local Love = require 'src/services/love'

local components = {
  '=sprites'
}

local system = function(sprites)
  local build_animation = function(sprite, frame_w, frame_h, img_w, img_h)
    local x = sprite.x or 0
    local y = sprite.y or 0
    local gap = sprite.gap or 0

    local grid = Anim8.newGrid(frame_w, frame_h, img_w, img_h, x, y, gap)

    local frames = sprite.frames or 1
    local duration = sprite.duration or 1

    return Anim8.newAnimation(grid(frames, 1), duration)
  end

  local sprite_config = require('src/components/sprites/' .. sprites)
  local loaded_set = {}
  loaded_set.image = Love.graphics.newImage(sprite_config.path)
  loaded_set.actions = {}
  local img_w = loaded_set.image:getWidth()
  local img_h = loaded_set.image:getHeight()

  for key, sprite in pairs(sprite_config.actions) do
    loaded_set.actions[key] = build_animation(
      sprite,
      sprite_config.width,
      sprite_config.height,
      img_w,
      img_h
    )
  end
  return loaded_set
end

return System(components, system)
