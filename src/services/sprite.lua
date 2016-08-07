local Anim8 = require 'lib/anim8'
local Love = require 'src/services/love'

-- Information about sprites we need to create
local sprite_maps = {}

sprite_maps.protagonist = {
  path = 'img/male-player.png',
  width = 64,
  height = 64,
  x = 0,
  y = 128
}

-- Example animated sprite
--sprite_maps.dove = {
  --path = 'img/dove.png',
  --width = 32,
  --height = 32,
  --frames = '1-4',
  --duration = 0.2,
  --x = 0,
  --y = 0
--}

local build_animation = function(map, image)
  local frame_w = map.width
  local frame_h = map.height

  local img_w = image:getWidth()
  local img_h = image:getHeight()

  local x = map.x or 0
  local y = map.y or 0
  local gap = map.gap or 0

  local grid = Anim8.newGrid(frame_w, frame_h, img_w, img_h, x, y, gap)

  local frames = map.frames
  local duration = map.duration

  return Anim8.newAnimation(grid(frames, 1), duration)
end

local build_quad = function(map, image)
  local img_w = image:getWidth()
  local img_h = image:getHeight()

  local x = map.x or 0
  local y = map.y or 0

  return Love.graphics.newQuad(x, y, map.width, map.height, img_w, img_h)
end

local build_sprites = function(maps)
  local sprites = {}

  for key, map in pairs(maps) do
    local image = Love.graphics.newImage(map.path)

    sprites[key] = {}
    sprites[key].image = image

    if (map.duration) then
      sprites[key].animation = build_animation(map, image)
    else
      sprites[key].quad = build_quad(map, image)
    end
  end
  return sprites
end

-- Processed sprites, exposed and ready for rendering
local list = build_sprites(sprite_maps)

return {
  list = list
}
