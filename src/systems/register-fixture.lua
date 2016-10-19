--- RegisterFixture
-- Build entity's box2d fixture when spawning

local System = require 'lib/system'

local Love = require 'src/services/love'

local components = {
  '_entity',
  'body',
  'shape'
}

local system = function(entity, body, shape, layer_index)
  local fixture = Love.physics.newFixture(body, shape)
  if entity.fixture then
    if entity.fixture.friction then
      fixture:setFriction(entity.fixture.friction)
    end
    if entity.fixture.restitution then
      fixture:setRestitution(entity.fixture.restitution)
    end
  end
  -- Fixtures in different layers cannot collide with each other
  fixture:setGroupIndex(layer_index)
  entity.fixture = fixture
end

return System(components, system)
