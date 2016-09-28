--- UpdatePlayerVelocity
-- Apply velocity on the x/y axis based on
-- active <input_direction>s on the player.

local System = require 'lib/system'
local Window = require 'src/services/window'

local components = {
  '-player_id',
  'acceleration',
  'body',
  'input_direction',
  'max_speed'
}

local system = function(acceleration, body, input_direction, max_speed)
  -- Get the body's current velocity so
  -- we can compound additional force.
  local vel_x, vel_y = body:getLinearVelocity()

  -- Go only left or right, but neither
  -- direction if the user presses both.
  if input_direction.left and not input_direction.right then
    -- Don't go over the player's max speed.
    if vel_x > max_speed * -1 then
      -- How quickly the player reaches max_speed depends on
      -- the user's acceleration. This isn't very noticeable
      -- but can affect the user's movement precision in bullet hells.
      vel_x = vel_x - acceleration
    end
  elseif input_direction.right and not input_direction.left then
    if vel_x < max_speed then
      vel_x = vel_x + acceleration
    end
  else
    vel_x = 0
  end

  if input_direction.up and not input_direction.down then
    if vel_y > max_speed * -1 then
      vel_y = vel_y - acceleration
    end
  elseif input_direction.down and not input_direction.up then
    if vel_y < max_speed then
      vel_y = vel_y + acceleration
    end
  else
    vel_y = 0
  end

  -- Check if player is going to run off the screen
  local pos_x, pos_y = body:getPosition()
  local boundary_x = Window.width - 38
  local boundary_y = Window.height - 38

  if (pos_x <= 4 and vel_x < 0) then
    vel_x = 0
  elseif (pos_x >= boundary_x and vel_x > 0) then
    vel_x = 0
  end

  if (pos_y <= 4 and vel_y < 0) then
    vel_y = 0
  elseif (pos_y >= boundary_y and vel_y > 0) then
    vel_y = 0
  end

  body:setLinearVelocity(vel_x, vel_y)
end

return System(components, system)
