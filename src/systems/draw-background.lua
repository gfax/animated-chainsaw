--- DrawBackground
-- Draw the currently-visible portion
-- of the currently-loaded background

local Love = require 'src/services/love'
local System = require 'lib/system'

local components = {
  '-active',
  'image',
  'map',
  'quads',
  'tile_w',
  'tile_h',
  '?pos_x',
  '?pos_y'
}

local system = function(image, map, quads, tile_w, tile_h, pos_x, pos_y)
  for col_index, col in ipairs(map) do
    for row_index, char in ipairs(col) do
      local quad = quads[char]
      pos_x = (pos_x or 0)
      pos_y = (pos_y or 0)
      local tile_pos_x = pos_x + (col_index - 1) * tile_w
      local tile_pos_y = pos_y + (row_index - 1) * tile_h
      Love.graphics.draw(
        image,
        quad,
        tile_pos_x,
        tile_pos_y
      )
    end
  end
end

return System(components, system)
