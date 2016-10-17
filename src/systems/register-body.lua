--- RegisterBody
-- Build entity's box2d body when spawning

local System = require 'lib/system'

local Love = require 'src/services/love'
local World = require 'src/services/world'

local components = {
  '=body'
}

local system = function(body, pos_x, pos_y)
  local new_body = Love.physics.newBody(
    World,
    pos_x,
    pos_y,
    body.type
  )
  if body.fixed_rotation then
    new_body:setFixedRotation(true)
  end
  return new_body
end

return System(components, system)
