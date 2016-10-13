return {
  acceleration = 140,
  actions = {
    'shoot_down',
    'shoot_left',
    'shoot_right',
    'shoot_up',
    'stand_down',
    'stand_left',
    'stand_right',
    'stand_up',
    'walk_down',
    'walk_left',
    'walk_right',
    'walk_up'
  },
  body = {
    fixed_rotation = true,
    type = 'dynamic'
  },
  fixture = {
    friction = 0
  },
  input = {
    down = false,
    left = false,
    right = false,
    up = false
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
