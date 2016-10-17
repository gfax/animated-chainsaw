--- UpdateEntityAnimation
-- Update entity sprites to the right frame

local System = require 'lib/system'

local components = {
  'body',
  '=current_action',
  '=sprites'
}

local system = function(body, current_action, sprites, dt)
  local vel_x, vel_y = body:getLinearVelocity()
  if vel_x > 0 then
    current_action = 'move_right'
  elseif vel_x <  0 then
    current_action = 'move_left'
  elseif vel_y > 0 then
    current_action = 'move_down'
  elseif vel_y < 0 then
    current_action = 'move_up'
  elseif current_action == 'move_down' then
    current_action = 'stand_down'
  elseif current_action == 'move_left' then
    current_action = 'stand_left'
  elseif current_action == 'move_right' then
    current_action = 'stand_right'
  elseif current_action == 'move_up' then
    current_action = 'stand_up'
  end
  sprites.actions[current_action]:update(dt)
  return current_action, sprites
end

return System(components, system)
