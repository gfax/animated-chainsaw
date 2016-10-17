--- RegisterInput
-- Register entity's callbacks for key presses / key releases

local System = require 'lib/system'

local Input = require 'src/services/input'

local components = {
  '_entity',
  '=input_actions'
}

local system = function(entity, input_actions)
  -- Provision "input" table to track state of all inputs
  entity.input = {}
  for key, val in pairs(input_actions) do
    local action = require('src/components/actions/' .. val)
    Input.register_key_press(key, action.begin, entity)
    Input.register_key_release(key, action.finish, entity)
  end
  return input_actions
end

return System(components, system)
