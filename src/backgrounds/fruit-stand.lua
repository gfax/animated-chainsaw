local image_path = 'img/general.png'

local background_string = [[
  ..12..
  LT34TR
  l****r
]]

local quad_map = {
  ['.'] = { -- grass
    pos_x = 32,
    pos_y = 352
  },
  ['*'] = { -- cobble
    pos_x = 32,
    pos_y = 32
  },
  ['L'] = { --top-left cobble
    pos_x = 0,
    pos_y = 0
  },
  ['T'] = { -- top cobble
    pos_x = 32,
    pos_y = 0
  },
  ['R'] = { -- top-right cobble
    pos_x = 64,
    pos_y = 0
  },
  ['l'] = { -- left cobble
    pos_x = 0,
    pos_y = 32
  },
  ['r'] = { -- right cobble
    pos_x = 64,
    pos_y = 32
  },
  ['1'] = { pos_x = 448, pos_y =  0 }, -- fruit-stand top-left
  ['2'] = { pos_x = 480, pos_y =  0 }, -- fruit-stand top-right
  ['3'] = { pos_x = 448, pos_y = 32 }, -- fruit-stand bottom-left
  ['4'] = { pos_x = 480, pos_y = 32 }
}

return {
  active = true,
  background_string = background_string,
  image_path = image_path,
  quad_map = quad_map,
  tile_w = 32,
  tile_h = 32
}
