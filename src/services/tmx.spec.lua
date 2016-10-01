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

    it('should parse maps with xml-format tilesets', function()
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
      assert.equal(type(results.tileset), 'table')
      assert.equal(results.tileset.columns, 16)
      assert.equal(results.tileset.source, 'img/general.png')
      assert.equal(results.tileset.tile_count, 256)
      assert.equal(results.tileset.tile_height, 32)
      assert.equal(results.tileset.tile_width, 32)
      assert.equal(results.tileset.transparency, 'ffffff')
    end)

    it('should parse maps with csv-format tilesets', function()
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
      assert.equal(type(results.tileset), 'table')
      assert.equal(results.tileset.columns, 16)
      assert.equal(results.tileset.source, 'img/general.png')
      assert.equal(results.tileset.tile_count, 256)
      assert.equal(results.tileset.tile_height, 32)
      assert.equal(results.tileset.tile_width, 32)
      assert.equal(results.tileset.transparency, 'ffffff')
    end)

    it('should parse gzip-compressed tilesets', function()
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
      assert.equal(type(results.tileset), 'table')
      assert.equal(results.tileset.columns, 16)
      assert.equal(results.tileset.source, 'img/general.png')
      assert.equal(results.tileset.tile_count, 256)
      assert.equal(results.tileset.tile_height, 32)
      assert.equal(results.tileset.tile_width, 32)
      assert.equal(results.tileset.transparency, 'ffffff')
    end)

    it('should parse zlib-compressed tilesets', function()
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
      assert.equal(type(results.tileset), 'table')
      assert.equal(results.tileset.columns, 16)
      assert.equal(results.tileset.source, 'img/general.png')
      assert.equal(results.tileset.tile_count, 256)
      assert.equal(results.tileset.tile_height, 32)
      assert.equal(results.tileset.tile_width, 32)
      assert.equal(results.tileset.transparency, 'ffffff')
    end)

    it('should parse object groups', function()
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
          <object id="1" name="lil grass box" type="cute" x="32" y="32" width="32" height="32" rotation="1.23">
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

      -- object_groups table results:
      -- {
      --   {
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
      --   }
      -- }

      local results = Tmx.parse('foo', test_tmx)

      assert.equal(#results.object_groups, 1)

      local object_group = results.object_groups[1]
      local object1 = object_group[1]
      assert.equal(object1.crazy, 'definitely')
      assert.equal(object1.height, 32)
      assert.equal(object1.name, 'lil grass box')
      assert.equal(object1.pos_x, 32)
      assert.equal(object1.pos_y, 32)
      assert.equal(object1.type, 'cute')
      assert.equal(object1.width, 32)

      local object2 = object_group[2]
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