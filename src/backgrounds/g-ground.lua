local image_path = 'img/general.png'

local background_string = [[
  .................g#######
  .................g#######
  ..LTTTTTTTTTTTR..g#######
  ..l***********r..g#######
  ..l***********r..g#######
  ..l***********r..g#######
  ..l***********r..g#######
  ..l***********r..g#######
  ..l***********r..g#######
  ..l***********r..g#######
  ..l***********r..g#######
  ..jvvvvvvvvvvvJ..g#######
  .................g#######
  .................g#######
  GGGGGGGGGGGGGGGGGV#######
  eeeeeeeeeeeeeeeeeE#######
  #########################
  #########################
  #########################
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
  ['j'] = { -- bottom-left cobble
    pos_x = 0,
    pos_y = 64
  },
  ['v'] = { -- bottom cobble
    pos_x = 32,
    pos_y = 64
  },
  ['J'] = { -- bottom-right cobble
    pos_x = 64,
    pos_y = 64
  },
  ['#'] = { -- water
    pos_x = 96,
    pos_y = 320
  },
  ['g'] = { -- w-grass-east
    pos_x = 64,
    pos_y = 352
  },
  ['G'] = { -- w-grass-south
    pos_x = 32,
    pos_y = 384
  },
  ['V'] = { -- w-grass-secorner
    pos_x = 64,
    pos_y = 384
  },
  ['e'] = { -- w-grass-botttomref
    pos_x = 32,
    pos_y = 416
  },
  ['E'] = { -- w-grass-secornerref
    pos_x = 64,
    pos_y = 416
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
