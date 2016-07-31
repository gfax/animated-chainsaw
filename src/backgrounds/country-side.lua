local image_path = 'img/countryside.png'

local background_string = [[
  ....bb......
  .f..bb......
  ....bb......
  ....ww..f...
  ............
  ............
  .f..........
  ........f...
  ............
  ............
  ....f.......
  ............
]]

local quad_map = {
  ['.'] = { -- grass
    pos_x = 0,
    pos_y = 0
  },
  ['w'] = { -- wood panel
    pos_x = 32,
    pos_y = 0
  },
  ['f'] = { --flowers
    pos_x = 0,
    pos_y = 32
  },
  ['b'] = { -- boxtop
    pos_x = 32,
    pos_y = 32
  }
}

return {
  active = true,
  background_string = background_string,
  image_path = image_path,
  quad_map = quad_map,
  tile_w = 32,
  tile_h = 32
}
