return {
  acceleration = 140,
  actions = {
    'shoot-down',
    'shoot-left',
    'shoot-right',
    'shoot-up',
    'stand-down',
    'stand-left',
    'stand-right',
    'stand-up',
    'move-down',
    'move-left',
    'move-right',
    'move-up'
  },
  body = {
    fixed_rotation = true,
    type = 'dynamic'
  },
  fixture = {
    friction = 0
  },
  input_actions = {
    down = 'move-down',
    left = 'move-left',
    right = 'move-right',
    up = 'move-up'
  },
  max_speed = 100,
  player_id = 1,
  shape = {
    height = 32,
    offset_x = 32,
    offset_y = 46,
    width = 32,
    type = 'rectangle'
  },
  sprites = 'protagonist'
}
