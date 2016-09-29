describe('services/tmx', function()

  --local Love
  local Tmx = require 'src/services/tmx'

  -- Mock Love dependency
  --before_each(function()
    --local love_mock = {}
    --package.loaded['src/services/love'] = love_mock
    --Love = love_mock
  --end)
  --after_each(function()
    --package.loaded['src/services/love'] = nil
  --end)

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
  end)

end)
