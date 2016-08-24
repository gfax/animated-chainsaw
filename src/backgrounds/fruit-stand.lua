local image_path = 'img/general.png'

local background_string = [[
  12
  34
]]

local quad_map = {
  ['1'] = { -- fruit-stand top-left
    pos_x = 448,
    pos_y =  0
  },
  ['2'] = { -- fruit-stand top-right
    pos_x = 480,
    pos_y =  0
  },
  ['3'] = { -- fruit-stand bottom-left
    pos_x = 448,
    pos_y = 32
  },
  ['4'] = {
    pos_x = 480,
    pos_y = 32
  }
}

return {
  active = true,
  background_string = background_string,
  image_path = image_path,
  quad_map = quad_map,
  tile_w = 32,
  tile_h = 32,
  pos_x = 256,
  pos_y = 64
}
