--- PlayerInput
-- Register player entity's inputs
local Input = require 'src/services/input'

local move_down_begin = function(entity)
  entity.input.down = true
end

local move_down_finish = function(entity)
  entity.input.down = false
end

local move_left_begin = function(entity)
  entity.input.left = true
end

local move_left_finish = function(entity)
  entity.input.left = false
end

local move_right_begin = function(entity)
  entity.input.right = true
end

local move_right_finish = function(entity)
  entity.input.right = false
end

local move_up_begin = function(entity)
  entity.input.up = true
end

local move_up_finish = function(entity)
  entity.input.up = false
end

local register = function(entity)
  if entity.player_id == 1 then
    Input.register_key_press('up', move_up_begin, entity)
    Input.register_key_press('left', move_left_begin, entity)
    Input.register_key_press('down', move_down_begin, entity)
    Input.register_key_press('right', move_right_begin, entity)
    Input.register_key_press('w', move_up_begin, entity)
    Input.register_key_press('a', move_left_begin, entity)
    Input.register_key_press('s', move_down_begin, entity)
    Input.register_key_press('d', move_right_begin, entity)

    Input.register_key_release('up', move_up_finish, entity)
    Input.register_key_release('left', move_left_finish, entity)
    Input.register_key_release('down', move_down_finish, entity)
    Input.register_key_release('right', move_right_finish, entity)
    Input.register_key_release('w', move_up_finish, entity)
    Input.register_key_release('a', move_left_finish, entity)
    Input.register_key_release('s', move_down_finish, entity)
    Input.register_key_release('d', move_right_finish, entity)
  end
end

return {
  register = register
}
