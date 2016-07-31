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
  'tile_h'
}

local system = function(image, map, quads, tile_w, tile_h)
  for col_index, col in ipairs(map) do
    for row_index, char in ipairs(col) do
      local quad = quads[char]
      local pos_x = (col_index - 1) * tile_w
      local pos_y = (row_index - 1) * tile_h
      Love.graphics.draw(
        image,
        quad,
        pos_x,
        pos_y
      )
    end
  end
end

return System(components, system)
