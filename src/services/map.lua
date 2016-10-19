--- Map service
-- Store and decode maps as needed

local Args = require 'src/services/args'
local Entity = require 'src/services/entity'
local Love = require 'src/services/love'
local Tmx = require 'src/services/tmx'
local Util = require 'src/services/util'
local World = require 'src/services/world'

local drawEntity = require 'src/systems/draw-entity'

-- Creates table of map filenames as keys
-- and their contents as parsed tables:
local get_map_tables = function(map_directory, map_file_ext)
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
      local parsed_content = Tmx.parse(file_name, file_content)
      map_tables[file_name_without_ext] = parsed_content
    end
  end

  return map_tables
end

local active_map
local map_directory = 'src/maps'
local map_file_ext = '.tmx'
local maps = get_map_tables(map_directory, map_file_ext)

local draw_objects = function(layer, layer_idx)
  -- Draw each entity that belongs to this layer
  for _, entity in ipairs(Entity.list) do
    drawEntity(entity, layer_idx)
  end
  -- Draw collision fixture shape's edges in debug mode
  if Args.get_arg('debug') then
    for _, fixture in ipairs(layer.objects) do
      local body = fixture:getBody()
      local shape = fixture:getShape()
      Love.graphics.setColor(255, 0, 0, 255)
      Love.graphics.polygon('line', body:getWorldPoints(shape:getPoints()))
      Love.graphics.setColor(255, 255, 255, 255)
    end
  end
end

local draw_tiles = function(layer, map)
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

local draw = function()
  local map = active_map
  for idx, layer in ipairs(map.layers) do
    if layer.type == 'tiles' then
      draw_tiles(layer, map)
    else
      draw_objects(layer, idx)
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

  local spawn_fixture = function(object, layer_index)
    local body = Love.physics.newBody(
      World,
      object.pos_x,
      object.pos_y,
      'static'
    )
    if object.rotation then
      body:setAngle(object.rotation)
    end
    local shape
    if object.points then
      shape = Love.physics.newPolygonShape(object.points)
    elseif object.width then
      shape = Love.physics.newRectangleShape(
        object.width / 2,
        object.height / 2,
        object.width,
        object.height
      )
    end

    if shape then
      local fixture = Love.physics.newFixture(body, shape)
      fixture:setGroupIndex(layer_index)
      return fixture
    end
    return nil
  end

  local load_fixtures = function(layer, layer_idx)
    local fixtures = {}
    for _, object in ipairs(layer.objects) do
      if object.name and object.type == 'entity' then
        Entity.spawn(object, layer_idx)
      else
        local collision_fixture = spawn_fixture(object, layer_idx)
        if collision_fixture then
          table.insert(fixtures, collision_fixture)
        end
      end
    end
    return fixtures
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
  for layer_idx, layer in ipairs(active_map.layers) do
    -- Apply collision fixtures
    if layer.type == 'objects' then
      active_map.layers[layer_idx].objects = load_fixtures(layer, layer_idx)
    end
  end

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
