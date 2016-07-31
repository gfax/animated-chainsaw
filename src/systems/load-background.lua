--- LoadBackground
-- Load a background in memory
-- (...and for now, set it as the current background)

local Love = require 'src/services/love'
local System = require 'lib/system'

local components = {
  '_entity',
  '-active',
  'background_string',
  'image_path',
  'quad_map',
  'tile_w',
  'tile_h'
}

local system = function(entity, background_string, image_path, quad_map, tile_w, tile_h)

  local build_quads = function(image, quad_info, tile_width, tile_height)
    local quads = {}
    for key, val in pairs(quad_info) do
      quads[key] = Love.graphics.newQuad(
        val['pos_x'],
        val['pos_y'],
        tile_width,
        tile_height,
        image:getWidth(),
        image:getHeight()
      )
    end
    return quads
  end

  local build_map = function(map_string)
    local map = {}
    -- Parser will match text between whitespaces and new lines
    local parser = '[^\n%s]+'
    local map_width = #(map_string:match(parser))
    for x = 1, map_width, 1 do
      map[x] = {}
    end
    local row_index = 1
    for row in map_string:gmatch(parser) do
      assert(#row == map_width,
        'Map is not aligned: width of row ' ..
        tostring(row_index) ..
        ' should be ' ..
        tostring(map_width) ..
        ', but it is ' ..
        tostring(#row)
      )
      local col_index = 1
      for char in row:gmatch('.') do
        map[col_index][row_index] = char
        col_index = col_index + 1
      end
      row_index = row_index + 1
    end
    return map
  end

  entity.image = Love.graphics.newImage(image_path)

  entity.quads = build_quads(
    entity.image,
    quad_map,
    tile_w,
    tile_h
  )

  entity.map = build_map(background_string)

end

return System(components, system)
