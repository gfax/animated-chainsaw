local Love = require 'src/services/love'
local PlayerInput = require 'src/services/player-input'
local Sprite = require 'src/services/sprite'
local Util = require 'src/services/util'
local World = require 'src/services/world'

local entity_directory = 'src/entities'

local get_entity_configs = function(directory)
  local entities = {}
  local file_list = Love.filesystem.getDirectoryItems(directory)
  for _, file_name in ipairs(file_list) do
    local file_name_without_ext = file_name:match('(.+)%..+')
    local entity = require(directory .. '/' .. file_name_without_ext)
    entities[file_name_without_ext] = entity
  end
  return entities
end

local entity_configs = get_entity_configs(entity_directory)
local entities = {}

local build_body = function(config, pos_x, pos_y)
  if not config.body then
    return nil
  end
  local body = Love.physics.newBody(
    World,
    pos_x,
    pos_y,
    config.body.type
  )
  if config.body.fixed_rotation then
    body:setFixedRotation(true)
  end
  return body
end

local build_shape = function(config)
  if not config.shape then
    return nil
  end
  assert(
    config.shape.type ~= nil,
    'Entity has no shape type.'
  )
  local shape
  if config.shape.type == 'rectangle' then
    shape = Love.physics.newRectangleShape(
      config.shape.offset_x or 0,
      config.shape.offset_y or 0,
      config.shape.width,
      config.shape.height
    )
  else
    shape = Love.physics.newPolygon(config.shape.points)
  end
  return shape
end

local build_fixture = function(config, body, shape)
  if not body or not shape then
    return nil
  end
  local fixture = Love.physics.newFixture(body, shape)
  if config.fixture then
    if config.fixture.friction then
      fixture:setFriction(config.fixture.friction)
    end
    if config.fixture.restitution then
      fixture:setRestitution(config.fixture.restitution)
    end
  end
  return fixture
end

local spawn = function(name, object)
  local entity_config = entity_configs[name]
  assert(
    entity_config ~= nil,
    'Map entity reference "' .. name .. '" not found.'
  )
  local entity = Util.copy(entity_config)
  entity.body = build_body(entity_config, object.pos_x, object.pos_y)
  entity.shape = build_shape(entity_config)
  entity.fixture = build_fixture(entity_config, entity.body, entity.shape)
  entity.sprites = Sprite.load_set(entity_config.sprites)
  entity.current_action = 'default'
  -- Kind of a mess right now
  if entity.player_id then
    PlayerInput.register(entity)
  end
  table.insert(entities, entity)
end

return {
  list = entities,
  spawn = spawn
}
