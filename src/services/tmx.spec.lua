describe('services/tmx', function()

  local Base64 = require 'src/services/base64'
  local Tmx

  -- Mock Love dependency
  before_each(function()
    local love_mock = {
      math = {
        decompress = function()
          -- Ascii representation of the decompressed byte string
          return Base64.decode('pAAAAKQAAACkAAAAoQAAAA==')
        end
      }
    }
    package.loaded['src/services/love'] = love_mock
  end)
  after_each(function()
    package.loaded['src/services/love'] = nil
  end)

  before_each(function()
    Tmx = require 'src/services/tmx'
  end)
  after_each(function()
    package.loaded['src/services/tmx'] = nil
    Tmx = nil
  end)

  describe('parse', function()
    it('should exist', function()
      assert.equal(type(Tmx.parse), 'function')
    end)

    it('should parse tilesets', function()
      local test_tmx = [[
        <?xml version="1.0" encoding="UTF-8"?>
        <map version="1.0" orientation="orthogonal" renderorder="right-down" width="2" height="2" tilewidth="32" tileheight="32" nextobjectid="1">
          <tileset firstgid="1" name="general" tilewidth="32" tileheight="32" tilecount="256" columns="16">
            <image source="../../img/general.png" trans="ffffff" width="512" height="512"/>
          </tileset>
          <tileset firstgid="257" name="countryside" tilewidth="24" tileheight="24" tilecount="4" columns="2">
            <image source="../../img/countryside.png" trans="000000" width="64" height="64"/>
          </tileset>
        </map>
      ]]

      local results = Tmx.parse('foo', test_tmx)
      assert.equal(results.columns, 2)

      assert.equal(type(results.tilesets), 'table')
      assert.equal(#results.tilesets, 2)

      local tileset1 = results.tilesets[1]
      assert.equal(tileset1.columns, 16)
      assert.equal(tileset1.source, 'img/general.png')
      assert.equal(tileset1.tile_count, 256)
      assert.equal(tileset1.tile_height, 32)
      assert.equal(tileset1.tile_width, 32)
      assert.equal(tileset1.transparency, 'ffffff')

      local tileset2 = results.tilesets[2]
      assert.equal(tileset2.columns, 2)
      assert.equal(tileset2.source, 'img/countryside.png')
      assert.equal(tileset2.tile_count, 4)
      assert.equal(tileset2.tile_height, 24)
      assert.equal(tileset2.tile_width, 24)
      assert.equal(tileset2.transparency, '000000')
    end)

    it('should parse xml-format tile layers', function()
      local test_tmx = [[
        <?xml version="1.0" encoding="UTF-8"?>
        <map version="1.0" orientation="orthogonal" renderorder="right-down" width="2" height="2" tilewidth="32" tileheight="32" nextobjectid="1">
         <tileset firstgid="1" name="general" tilewidth="32" tileheight="32" tilecount="256" columns="16">
          <image source="../../img/general.png" trans="ffffff" width="512" height="512"/>
         </tileset>
         <layer name="Tile Layer 1" width="2" height="2">
          <data>
           <tile gid="1"/>
           <tile gid="2"/>
           <tile gid="17"/>
           <tile gid="18"/>
          </data>
         </layer>
        </map>
      ]]

      local results = Tmx.parse('foo', test_tmx)
      assert.equal(results.columns, 2)
      assert.equal(#results.layers, 1)
      assert.equal(#results.layers[1].data, 4)
      assert.equal(results.layers[1].data[1], 1)
      assert.equal(results.layers[1].data[2], 2)
      assert.equal(results.layers[1].data[3], 17)
      assert.equal(results.layers[1].data[4], 18)

      assert.equal(results.orientation, 'orthogonal')
      assert.equal(results.render_order, 'right-down')
      assert.equal(results.rows, 2)
      assert.equal(results.tile_height, 32)
      assert.equal(results.tile_width, 32)

      assert.equal(type(results.tilesets), 'table')
      assert.equal(#results.tilesets, 1)

      local tileset = results.tilesets[1]
      assert.equal(tileset.columns, 16)
      assert.equal(tileset.source, 'img/general.png')
      assert.equal(tileset.tile_count, 256)
      assert.equal(tileset.tile_height, 32)
      assert.equal(tileset.tile_width, 32)
      assert.equal(tileset.transparency, 'ffffff')
    end)

    it('should parse csv-format tile layers', function()
      local test_tmx = [[
        <?xml version="1.0" encoding="UTF-8"?>
        <map version="1.0" orientation="orthogonal" renderorder="right-down" width="2" height="2" tilewidth="32" tileheight="32" nextobjectid="1">
         <tileset firstgid="1" name="general" tilewidth="32" tileheight="32" tilecount="256" columns="16">
          <image source="../../img/general.png" trans="ffffff" width="512" height="512"/>
         </tileset>
         <layer name="My base layer" width="2" height="2">
          <data encoding="csv">
           1,2,
           17,18
          </data>
         </layer>
        </map>
      ]]

      local results = Tmx.parse('foo', test_tmx)
      assert.equal(results.columns, 2)
      assert.equal(#results.layers, 1)
      assert.equal(#results.layers[1].data, 4)
      assert.equal(results.layers[1].data[1], 1)
      assert.equal(results.layers[1].data[2], 2)
      assert.equal(results.layers[1].data[3], 17)
      assert.equal(results.layers[1].data[4], 18)

      assert.equal(results.orientation, 'orthogonal')
      assert.equal(results.render_order, 'right-down')
      assert.equal(results.rows, 2)
      assert.equal(results.tile_height, 32)
      assert.equal(results.tile_width, 32)

      assert.equal(type(results.tilesets), 'table')
      assert.equal(#results.tilesets, 1)

      local tileset = results.tilesets[1]
      assert.equal(tileset.columns, 16)
      assert.equal(tileset.source, 'img/general.png')
      assert.equal(tileset.tile_count, 256)
      assert.equal(tileset.tile_height, 32)
      assert.equal(tileset.tile_width, 32)
      assert.equal(tileset.transparency, 'ffffff')
    end)

    it('should parse gzip-compressed tile layers', function()
      local test_tmx = [[
        <?xml version="1.0" encoding="UTF-8"?>
        <map version="1.0" orientation="orthogonal" renderorder="right-down" width="2" height="2" tilewidth="32" tileheight="32" nextobjectid="2">
         <tileset firstgid="1" name="general" tilewidth="32" tileheight="32" tilecount="256" columns="16">
          <image source="../../img/general.png" trans="ffffff" width="512" height="512"/>
         </tileset>
         <layer name="My base layer" width="2" height="2">
          <data encoding="base64" compression="gzip">
           eJxbwsDAsASKFwIxABmkAo4=
          </data>
         </layer>
        </map>
      ]]

      local results = Tmx.parse('foo', test_tmx)
      assert.equal(results.columns, 2)
      assert.equal(#results.layers, 1)
      assert.equal(#results.layers[1].data, 4)
      assert.equal(results.layers[1].data[1], 164)
      assert.equal(results.layers[1].data[2], 164)
      assert.equal(results.layers[1].data[3], 164)
      assert.equal(results.layers[1].data[4], 161)

      assert.equal(results.orientation, 'orthogonal')
      assert.equal(results.render_order, 'right-down')
      assert.equal(results.rows, 2)
      assert.equal(results.tile_height, 32)
      assert.equal(results.tile_width, 32)

      assert.equal(type(results.tilesets), 'table')
      assert.equal(#results.tilesets, 1)

      local tileset = results.tilesets[1]
      assert.equal(tileset.columns, 16)
      assert.equal(tileset.source, 'img/general.png')
      assert.equal(tileset.tile_count, 256)
      assert.equal(tileset.tile_height, 32)
      assert.equal(tileset.tile_width, 32)
      assert.equal(tileset.transparency, 'ffffff')
    end)

    it('should parse zlib-compressed tile layers', function()
      local love_mock = {
        math = {
          decompress = function()
            return Base64.decode('pAAAAKQAAACkAAAAoQAAAA==')
          end
        }
      }
      package.loaded['src/services/love'] = love_mock
      local test_tmx = [[
        <?xml version="1.0" encoding="UTF-8"?>
        <map version="1.0" orientation="orthogonal" renderorder="right-down" width="2" height="2" tilewidth="32" tileheight="32" nextobjectid="2">
         <tileset firstgid="1" name="general" tilewidth="32" tileheight="32" tilecount="256" columns="16">
          <image source="../../img/general.png" trans="ffffff" width="512" height="512"/>
         </tileset>
         <layer name="My base layer" width="2" height="2">
          <data encoding="base64" compression="zlib">
           eJxbwsDAsASKFwIxABmkAo4=
          </data>
         </layer>
         <objectgroup name="collision">
          <object id="1" name="lil grass box" type="cute" x="32" y="32" width="32" height="32">
           <properties>
            <property name="crazy" value="definitely"/>
           </properties>
          </object>
          <object id="28" name="Triangle" x="608" y="128">
           <polygon points="0,0 96,96 0,96"/>
          </object>
         </objectgroup>
        </map>
      ]]

      local results = Tmx.parse('foo', test_tmx)
      assert.equal(results.columns, 2)
      assert.equal(#results.layers, 2)

      local layer1 = results.layers[1]
      assert.equal(type(layer1), 'table')
      assert.equal(layer1.type, 'tiles')
      assert.equal(type(layer1.data), 'table')
      assert.equal(#layer1.data, 4)
      assert.equal(layer1.data[1], 164)
      assert.equal(layer1.data[2], 164)
      assert.equal(layer1.data[3], 164)
      assert.equal(layer1.data[4], 161)

      local layer2 = results.layers[2]
      assert.equal(type(layer2), 'table')
      assert.equal(layer2.type, 'objects')
      assert.equal(type(layer2.objects), 'table')

      assert.equal(results.orientation, 'orthogonal')
      assert.equal(results.render_order, 'right-down')
      assert.equal(results.rows, 2)
      assert.equal(results.tile_height, 32)
      assert.equal(results.tile_width, 32)

      assert.equal(type(results.tilesets), 'table')
      assert.equal(#results.tilesets, 1)

      local tileset = results.tilesets[1]
      assert.equal(tileset.columns, 16)
      assert.equal(tileset.source, 'img/general.png')
      assert.equal(tileset.tile_count, 256)
      assert.equal(tileset.tile_height, 32)
      assert.equal(tileset.tile_width, 32)
      assert.equal(tileset.transparency, 'ffffff')
    end)

    it('should parse object layers', function()
      local test_tmx = [[
        <?xml version="1.0" encoding="UTF-8"?>
        <map version="1.0" orientation="orthogonal" renderorder="right-down" width="2" height="2" tilewidth="32" tileheight="32" nextobjectid="2">
         <tileset firstgid="1" name="general" tilewidth="32" tileheight="32" tilecount="256" columns="16">
          <image source="../../img/general.png" trans="ffffff" width="512" height="512"/>
         </tileset>
         <layer name="Tile Layer 1" width="2" height="2">
          <data>
           <tile gid="1"/>
           <tile gid="2"/>
           <tile gid="17"/>
           <tile gid="18"/>
          </data>
         </layer>
         <objectgroup name="collision">
          <object id="1" name="lil grass box" type="cute" x="32" y="32" width="32" height="32" rotation="-45">
           <properties>
            <property name="crazy" value="definitely"/>
           </properties>
          </object>
          <object id="28" name="Triangle" x="608" y="128">
           <polygon points="0,0 96,96 0,96"/>
          </object>
         </objectgroup>
        </map>
      ]]

      -- example object layer:
      -- {
      --   objects = {
      --     {
      --       crazy = 'definitely',
      --       height = 32,
      --       name = 'lil grass box',
      --       pos_x = 32,
      --       pos_y = 32,
      --       type = 'cute',
      --       width = 32
      --     },
      --     {
      --       name = 'Triangle',
      --       points = { 0, 0, 96, 96, 0, 96 },
      --       pos_x = 608,
      --       pos_y = 128
      --     }
      --   },
      --   type = 'objects'
      -- }

      local results = Tmx.parse('foo', test_tmx)

      assert.equal(#results.layers, 2)

      local object_layer = results.layers[2]
      assert.equal(type(object_layer), 'table')
      assert.equal(object_layer.type, 'objects')
      assert.equal(type(object_layer.objects), 'table')

      local object1 = object_layer.objects[1]
      assert.equal(object1.crazy, 'definitely')
      assert.equal(object1.height, 32)
      assert.equal(object1.name, 'lil grass box')
      assert.equal(object1.pos_x, 32)
      assert.equal(object1.pos_y, 32)
      -- Convert tiled rotation degrees to box2d radians
      assert.equal(object1.rotation, math.rad(-45))
      assert.equal(object1.type, 'cute')
      assert.equal(object1.width, 32)

      local object2 = object_layer.objects[2]
      assert.equal(object2.name, 'Triangle')
      assert.equal(type(object2.points), 'table')
      assert.equal(#object2.points, 6)
      assert.equal(object2.points[1], 0)
      assert.equal(object2.points[2], 0)
      assert.equal(object2.points[3], 96)
      assert.equal(object2.points[4], 96)
      assert.equal(object2.points[5], 0)
      assert.equal(object2.points[6], 96)
      assert.equal(object2.pos_x, 608)
      assert.equal(object2.pos_y, 128)
    end)
  end)

end)
