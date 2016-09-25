--- Map service
-- Store and decode maps as needed

local Base64 = require 'src/services/base64'
local Love = require 'src/services/love'
local Xml = require 'src/services/xml'
local Util = require 'src/services/util'

-- Creates table of map filenames as keys
-- and their contents as parsed tables:
-- {
--   columns = 2,
--   image = <love image>,
--   layers = {
--     {
--       data = { 18, 17, 2, 1 },
--       height = "2",
--       width = "2",
--       x = 0,
--       y = 0
--     }
--   },
--   object_groups = {
--     { ... }
--   },
--   orientation = "orthogonal",
--   quads = { <love quad>, <love quad>, ... },
--   render_order = "right-down",
--   rows = 2,
--   tile_height = 32,
--   tile_width = 32,
--   tileset = {
--     columns = 16,
--     source = "img/general.png",
--     tile_count = 256,
--     tile_height = 32,
--     tile_width = 32,
--     transparency = "ffffff"
--   }
-- }

local get_map_tables = function(map_directory, map_file_ext)
  local parse_layer_data_xml = function(tileset)
    local parsed_table = {}
    for i = 1, #tileset do
      --table.insert(parsed_table, 1, tonumber(tileset[i].xarg.gid))
      Util.push(parsed_table, tonumber(tileset[i].xarg.gid))
    end
    return parsed_table
  end

  local parse_layer_data_csv = function(tileset)
    local parsed_table = {}
    local i = 1
    for str in string.gmatch(tileset[i], '([^,]+)') do
      Util.push(parsed_table, tonumber(str))
      i = i + 1
    end
    return parsed_table
  end

  local parse_layer = function(raw_layer_data, error_suffix)
    local formatted_layer = {}
    formatted_layer.data = {}
    formatted_layer.height = raw_layer_data.xarg.height
    formatted_layer.width = raw_layer_data.xarg.width
    formatted_layer.pos_x = (raw_layer_data.xarg.x or 0)
    formatted_layer.pos_y = (raw_layer_data.xarg.y or 0)
    -- The tileset data is stored in XML format
    if not raw_layer_data[1].xarg.encoding then
      formatted_layer.data = parse_layer_data_xml(raw_layer_data[1])
    elseif raw_layer_data[1].xarg.encoding == 'base64' then
      local tile_data_string = raw_layer_data[1][1]
      -- Strip newlines and whitespaces
      tile_data_string = tile_data_string:gsub('%s+', '')
      tile_data_string = Base64.decode(tile_data_string)

      local compression = raw_layer_data[1].xarg.compression
      if not compression then
        for i = 1, #tile_data_string, 4 do
          table.insert(formatted_layer.data, string.byte(tile_data_string, i))
        end
      elseif compression == 'gzip' or compression == 'zlib' then
        tile_data_string = Love.math.decompress(tile_data_string, compression)
        -- Glue together an integer from four bytes. Little endian
        formatted_layer.data = {}
        -- Decimal values for binary digits
        local bin = {}
        local mult = 1
        for i = 1, 40 do
            bin[i] = mult
            mult = mult * 2
        end
        for i = 1, #tile_data_string, 4 do
          -- Glue together an integer from four bytes. Little endian
          local int = string.byte(tile_data_string, i) % bin[9] +
            string.byte(tile_data_string, i + 1) % bin[9] * bin[9] +
            string.byte(tile_data_string, i + 2) % bin[9] * bin[17] +
            string.byte(tile_data_string, i + 3) % bin[9] * bin[25]
          formatted_layer.data[#formatted_layer.data + 1] = int
        end
      else
        assert(
          false,
          'Only zlib and gzip map compressions are supported.' ..
          'Found "' .. compression .. '"' .. error_suffix
        )
      end
    elseif raw_layer_data[1].xarg.encoding == 'csv' then
      formatted_layer.data = parse_layer_data_csv(raw_layer_data[1])
    else
      assert(
        false,
        'Unexpected Tiled layer encoding "' ..
        raw_layer_data[1].xarg.encoding ..
        '" set' .. error_suffix
      )
    end
    return formatted_layer
  end

  local parse_object_group = function(raw_object_group, error_suffix)
    local formatted_object_group = {}
    assert(
      raw_object_group[1].label == 'object',
      'Cannot find objects in object group' .. error_suffix
    )
    for _, raw_object in ipairs(raw_object_group) do
      local formatted_object = {
        label = raw_object[1].label,
        points = raw_object[1].xarg.points,
        pos_x = tonumber(raw_object.xarg.x),
        pos_y = tonumber(raw_object.xarg.y)
      }
      Util.push(formatted_object_group, formatted_object)
    end
    return formatted_object_group
  end

  local parse_tileset = function(raw_tileset_data, error_suffix)
    local formatted_tileset = {}
    assert(
      raw_tileset_data[1].label == 'image',
      'Expected the tileset data to be an image. Got "' ..
      raw_tileset_data[1].label .. '"' .. error_suffix
    )
    assert(
      raw_tileset_data[1].xarg.source ~= nil,
      'Expected a tileset image source. Got nil' .. error_suffix
    )
    assert(
      raw_tileset_data.xarg.columns ~= nil,
      'Expected a defined set of tileset columns. Got nil' .. error_suffix
    )
    assert(
      raw_tileset_data.xarg.tilecount ~= nil,
      'Expected a total tile count for the given tileset. Got nil' .. error_suffix
    )
    if raw_tileset_data[1].xarg.trans then
      formatted_tileset.transparency = raw_tileset_data[1].xarg.trans
    end
    formatted_tileset.source = raw_tileset_data[1].xarg.source:gsub('%.%./', '')
    formatted_tileset.columns = tonumber(raw_tileset_data.xarg.columns)
    formatted_tileset.tile_count = tonumber(raw_tileset_data.xarg.tilecount)
    formatted_tileset.tile_height = tonumber(raw_tileset_data.xarg.tileheight)
    formatted_tileset.tile_width = tonumber(raw_tileset_data.xarg.tilewidth)
    return formatted_tileset
  end

  local parse_content = function(file_name, raw_file_content)
    -- This will be our map's final table:
    local parsed_map = {
      layers = {},
      object_groups = {}
    }
    local parsed_xml = Xml.parse(raw_file_content)[2]
    local error_suffix = ' for Tiled map "' .. file_name .. '".'
    assert(
      parsed_xml ~= nil,
      'Cannot find map element' .. error_suffix
    )
    assert(
      parsed_xml.xarg.orientation == 'orthogonal',
      'Unsupported map type "' .. parsed_xml.xarg.orientation .. '"' ..
      error_suffix
    )
    assert(
      parsed_xml.xarg.renderorder == 'right-down',
      'Only "right-down" map render order supported, but found order set to "' ..
      parsed_xml.xarg.renderorder .. '"' .. error_suffix
    )
    parsed_map.rows = tonumber(parsed_xml.xarg.height)
    parsed_map.columns = tonumber(parsed_xml.xarg.width)
    parsed_map.orientation = parsed_xml.xarg.orientation
    parsed_map.render_order = parsed_xml.xarg.renderorder
    parsed_map.tile_height = tonumber(parsed_xml.xarg.tileheight)
    parsed_map.tile_width = tonumber(parsed_xml.xarg.tilewidth)
    for _, element in ipairs(parsed_xml) do
      if element.label == 'layer' then
        local parsed_layer = parse_layer(element, error_suffix)
        Util.push(parsed_map.layers, parsed_layer)
      elseif element.label == 'objectgroup' then
        local parsed_object_group = parse_object_group(element, error_suffix)
        Util.push(parsed_map.object_groups, parsed_object_group)
      elseif element.label == 'tileset' then
        parsed_map.tileset = parse_tileset(element, error_suffix)
      end
    end
    assert(
      parsed_map.orientation ~= nil,
      'Unable to set map orientation' .. error_suffix
    )
    assert(
      parsed_map.render_order ~= nil,
      'Unable to set map render order' .. error_suffix
    )
    assert(
      parsed_map.tile_height ~= nil,
      'Unable to set map tile height' .. error_suffix
    )
    assert(
      parsed_map.tile_width ~= nil,
      'Unable to set map tile width' .. error_suffix
    )
    return parsed_map
  end

  local map_tables = {}
  local file_list = Love.filesystem.getDirectoryItems(map_directory)
  for _, file_name in ipairs(file_list) do
    local file_ext = string.sub(file_name, -string.len(map_file_ext))
    -- Only keep files matching the tiled file extension
    if (file_ext == map_file_ext) then
      -- ie., "src/maps/general.tmx"
      local file_path = map_directory .. '/' .. file_name
      -- ie., "general" for "general.tmx"
      local file_name_without_ext = file_name:match('(.+)%..+')
      local file_content = Love.filesystem.read(file_path)
      -- We get an array of elements, bu only need the map element
      local parsed_content = parse_content(file_name, file_content)
      map_tables[file_name_without_ext] = parsed_content
    end
  end

  return map_tables
end

local active_map
local map_directory = 'src/maps'
local map_file_ext = '.tmx'
local maps = get_map_tables(map_directory, map_file_ext)

local draw = function()
  local map = active_map

  for _, layer in ipairs(map.layers) do
    for i, tile in ipairs(layer.data) do
      -- Skip unset tiles
      if tile ~= 0 then
        local tile_pos_x = map.tile_width * ((i - 1) % map.columns)
        local tile_pos_y = map.tile_height * math.floor((i - 1) / map.rows)
        Love.graphics.draw(
          map.image,
          map.quads[tile],
          tile_pos_x,
          tile_pos_y
        )
      end
    end
  end
end

local load = function(map_name)
  local load_image = function(map)
    local path = map.tileset.source
    return Love.graphics.newImage(path)
  end

  local load_quads = function(map, image)
    local quads = {}
    local row_count = map.tileset.tile_count / map.tileset.columns
    local image_width = image:getWidth()
    local image_height = image:getHeight()
    local quad_idx = 1
    for row = 1, row_count do
      for column = 1, map.tileset.columns do
        local tile_x = map.tile_width * (column - 1)
        local tile_y = map.tile_height * (row - 1)
        quads[quad_idx] = Love.graphics.newQuad(
          tile_x,
          tile_y,
          map.tile_width,
          map.tile_height,
          image_width,
          image_height
        )
        quad_idx = quad_idx + 1
      end
    end
    return quads
  end

  assert(
    type(map_name) == 'string',
    'Expected map_name string parameter. Got "' .. type(map_name) .. '".'
  )
  active_map = Util.copy(maps[map_name])
  assert(
    maps[map_name] ~= nil,
    'Could not find indexed map "' .. map_name .. '".'
  )
  active_map.image = load_image(active_map)
  active_map.quads = load_quads(active_map, active_map.image)

  return active_map
end

local unload = function(map_name)
  assert(
    maps[map_name] ~= nil,
    'Could not find indexed map "' .. map_name .. '".'
  )
  maps[map_name].image = nil
  maps[map_name].quads = nil
end

return {
  --- Render a map on screen. Map names are based
  -- on the filename. For instance, "general.tmx"
  -- would have a map name of "general".
  -- @param {string} map_name - name of map to draw
  -- @return {nil}
  draw = draw,
  load = load,
  --- Set loaded images and quads for a given map to nil.
  -- would have a map name of "general".
  -- @param {string} map_name - name of the tmx file to load
  -- @return {table} - parsed Tiled map data
  unload = unload
}
