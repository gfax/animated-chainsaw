--- Input config
-- Load and store input functions (hard-coded for now)

local Entity = require 'src/services/entity'
local Input = require 'src/services/input'
local Love = require 'src/services/love'
local UpdatePlayerDirection = require 'src/systems/update-player-direction'

local actions = {
  quit = {
    fn = function() Love.event.quit() end
  },
  player1_down = {
    label = 'Move down',
    fn = function()
      UpdatePlayerDirection(Entity.list, 1, 'down', true)
    end,
    release_fn = function()
      UpdatePlayerDirection(Entity.list, 1, 'down', false)
    end
  },
  player1_left = {
    label = 'Move left',
    fn = function()
      UpdatePlayerDirection(Entity.list, 1, 'left', true)
    end,
    release_fn = function()
      UpdatePlayerDirection(Entity.list, 1, 'left', false)
    end
  },
  player1_right = {
    label = 'Move right',
    fn = function()
      UpdatePlayerDirection(Entity.list, 1, 'right', true)
    end,
    release_fn = function()
      UpdatePlayerDirection(Entity.list, 1, 'right', false)
    end
  },
  player1_up = {
    label = 'Move up',
    fn = function()
      UpdatePlayerDirection(Entity.list, 1, 'up', true)
    end,
    release_fn = function()
      UpdatePlayerDirection(Entity.list, 1, 'up', false)
    end
  }
}

local update = function()
  -- Hard-code some default key maps:
  Input.register_key_press('escape', actions.quit.fn)
  Input.register_key_press('up', actions.player1_up.fn)
  Input.register_key_press('left', actions.player1_left.fn)
  Input.register_key_press('down', actions.player1_down.fn)
  Input.register_key_press('right', actions.player1_right.fn)
  Input.register_key_press('w', actions.player1_up.fn)
  Input.register_key_press('a', actions.player1_left.fn)
  Input.register_key_press('s', actions.player1_down.fn)
  Input.register_key_press('d', actions.player1_right.fn)

  Input.register_key_release('up', actions.player1_up.release_fn)
  Input.register_key_release('left', actions.player1_left.release_fn)
  Input.register_key_release('down', actions.player1_down.release_fn)
  Input.register_key_release('right', actions.player1_right.release_fn)
  Input.register_key_release('w', actions.player1_up.release_fn)
  Input.register_key_release('a', actions.player1_left.release_fn)
  Input.register_key_release('s', actions.player1_down.release_fn)
  Input.register_key_release('d', actions.player1_right.release_fn)
end

return {
  update = update
}
