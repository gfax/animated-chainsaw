--- UpdatePlayerVelocity
-- Apply velocity on the x/y axis based on
-- active <input>s on the player.

local System = require 'lib/system'

local components = {
  '-player_id',
  'acceleration',
  'body',
  'input',
  'max_speed'
}

local system = function(acceleration, body, input, max_speed)
  -- Get the body's current velocity so
  -- we can compound additional force.
  local vel_x, vel_y = body:getLinearVelocity()

  -- Go only left or right, but neither
  -- direction if the user presses both.
  if input.left and not input.right then
    -- Don't go over the player's max speed.
    if vel_x > max_speed * -1 then
      -- How quickly the player reaches max_speed depends on
      -- the user's acceleration. This isn't very noticeable
      -- but can affect the user's movement precision in bullet hells.
      vel_x = vel_x - acceleration
    end
  elseif input.right and not input.left then
    if vel_x < max_speed then
      vel_x = vel_x + acceleration
    end
  else
    vel_x = 0
  end

  if input.up and not input.down then
    if vel_y > max_speed * -1 then
      vel_y = vel_y - acceleration
    end
  elseif input.down and not input.up then
    if vel_y < max_speed then
      vel_y = vel_y + acceleration
    end
  else
    vel_y = 0
  end

  -- Check if player is going to run off the screen
  local pos_x, pos_y = body:getPosition()

  if (pos_x <= 4 and vel_x < 0) then
    vel_x = 0
  end

  if (pos_y <= 4 and vel_y < 0) then
    vel_y = 0
  end

  body:setLinearVelocity(vel_x, vel_y)
end

return System(components, system)
