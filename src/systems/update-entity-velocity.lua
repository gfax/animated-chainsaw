--- UpdateEntityVelocity
-- Apply basic velocity boundaries.

local System = require 'lib/system'

local components = {
  'body',
  'max_speed'
}

local system = function(body, max_speed)
  local vel_x, vel_y = body:getLinearVelocity()

  -- Limit the entity's maximum velocity
  if vel_x > max_speed then
    vel_x = max_speed
  elseif vel_x < max_speed * -1 then
    vel_x = max_speed * -1
  end

  if vel_y > max_speed then
    vel_y = max_speed
  elseif vel_y < max_speed * -1 then
    vel_y = max_speed * -1
  end

  body:setLinearVelocity(vel_x, vel_y)
end

return System(components, system)
