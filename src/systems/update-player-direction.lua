--- UpdatePlayerDirection
-- Append or remove an <input_direction> from a player
-- entity, to which the player velocity can be
-- calculated by the update-player-velocity system.

local System = require 'lib/system'

local components = {
  'player_id',
  'input_direction'
}

local system = function(player_id, input_direction, target_player_id, key, key_pressed)
  if (player_id == target_player_id) then
    -- Apply or remove the <input_direction>'s <key> based
    -- on whether <key_pressed> boolean is true or false.
    input_direction[key] = key_pressed
  end
end

return System(components, system)
