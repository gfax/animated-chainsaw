describe('services/map', function()

  local Love
  local Map

  -- Mock Love dependency
  before_each(function()
    local love_mock = {
      filesystem = {
        getDirectoryItems = function()
          return { 'foo.tmx', 'foo.bar' }
        end,
        read = function()
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
          return test_tmx
        end
      },
      graphics = {
        draw = function()
        end,
        newImage = function()
          return {
            getHeight = function()
              return 512
            end,
            getWidth = function()
              return 512
            end
          }
        end,
        newQuad = function(tile_x, tile_y, tile_w, tile_h, img_w, img_h)
          return {
            tile_x = tile_x,
            tile_y = tile_y,
            tile_w = tile_w,
            tile_h = tile_h,
            img_w = img_w,
            img_h = img_h
          }
        end
      }
    }
    package.loaded['src/services/love'] = love_mock
    Love = love_mock
  end)
  after_each(function()
    package.loaded['src/services/love'] = nil
  end)

  ---- Mock Util dependency
  --before_each(function()
    --local util_mock = {
      --copy = function(thing)
        --return thing
      --end
    --}
    --package.loaded['src/services/util'] = util_mock
  --end)
  --after_each(function()
    --package.loaded['src/services/util'] = nil
  --end)

  -- Reload main service between tests to wipe states
  before_each(function()
    Map = require 'src/services/map'
  end)
  after_each(function()
    Map = nil
    package.loaded['src/services/map'] = nil
  end)

  describe('load', function()
    it('should exist', function()
      assert.equal(type(Map.load), 'function')
    end)

    it('should assert a valid map name is given', function()
      assert.errors(function()
        Map.load('foobar')
      end)
    end)

    it('should parse maps with xml-format tilesets', function()
      local xml_mock = {
        parse = function()
          local parsed_xml = {
            '        <?xml version="1.0" encoding="UTF-8"?>\n        ',
            {
              {
                {
                  empty = 1,
                  label = 'image',
                  xarg = {
                    height = '512',
                    source = '../../img/general.png',
                    trans = 'ffffff',
                    width = '512'
                  }
                },
                label = 'tileset',
                xarg = {
                  columns = '16',
                  firstgid = '1',
                  name = 'general',
                  tilecount = '256',
                  tileheight = '32',
                  tilewidth = '32'
                }
              },
              {
                {
                  {
                    empty = 1,
                    label = 'tile',
                    xarg = {
                      gid = '1'
                    }
                  },
                  {
                    empty = 1,
                    label = 'tile',
                    xarg = {
                      gid = '2'
                    }
                  },
                  {
                    empty = 1,
                    label = 'tile',
                    xarg = {
                      gid = '17'
                    }
                  },
                  {
                    empty = 1,
                    label = 'tile',
                    xarg = {
                      gid = '18'
                    }
                  },
                  label = 'data',
                  xarg = {}
                },
                label = 'layer',
                xarg = {
                  height = '2',
                  name = 'Tile Layer 1',
                  width = '2'
                }
              },
              label = 'map',
              xarg = {
                height = '2',
                nextobjectid = '1',
                orientation = 'orthogonal',
                renderorder = 'right-down',
                tileheight = '32',
                tilewidth = '32',
                version = '1.0',
                width = '2'
              }
            }
          }
          return parsed_xml
        end
      }
      package.loaded['src/services/xml'] = xml_mock

      local results = Map.load('foo')
      assert.equal(results.columns, 2)
      assert.equal(type(results.image), 'table')
      assert.equal(#results.layers, 1)
      assert.equal(#results.layers[1].data, 4)
      assert.equal(results.layers[1].data[1], 1)
      assert.equal(results.layers[1].data[2], 2)
      assert.equal(results.layers[1].data[3], 17)
      assert.equal(results.layers[1].data[4], 18)
      assert.equal(results.orientation, 'orthogonal')
      assert.equal(#results.quads, 256)
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

      package.loaded['src/services/xml'] = nil
    end)

    it('should parse maps with csv-format tilesets', function()
      local xml_mock = {
        parse = function()
          local parsed_xml = {
            {
              {
                empty = 1,
                label = 'image',
                xarg = {
                  height = '512',
                  source = '../../img/general.png',
                  trans = 'ffffff',
                  width = '512'
                }
              },
              label = 'tileset',
              xarg = {
                columns = '16',
                firstgid = '1',
                name = 'general',
                tilecount = '256',
                tileheight = '32',
                tilewidth = '32'
              }
            },
            {
              { '\n164,164,\n164,161\n',
                label = 'data',
                xarg = {
                  encoding = 'csv'
                }
              },
              label = 'layer',
              xarg = {
                height = '2',
                name = 'My base layer',
                width = '2'
              }
            },
            label = 'map',
            xarg = {
              height = '2',
              nextobjectid = '1',
              orientation = 'orthogonal',
              renderorder = 'right-down',
              tileheight = '32',
              tilewidth = '32',
              version = '1.0',
              width = '2'
            }
          }
          return parsed_xml
        end
      }
      package.loaded['src/services/xml'] = xml_mock

      local results = Map.load('foo')
      assert.equal(results.columns, 2)
      assert.equal(type(results.image), 'table')
      assert.equal(#results.layers, 1)
      assert.equal(#results.layers[1].data, 4)
      assert.equal(results.layers[1].data[1], 1)
      assert.equal(results.layers[1].data[2], 2)
      assert.equal(results.layers[1].data[3], 17)
      assert.equal(results.layers[1].data[4], 18)
      assert.equal(results.orientation, 'orthogonal')
      assert.equal(#results.quads, 256)
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

      package.loaded['src/services/xml'] = nil
    end)
  end)

  describe('draw', function()
    it('should exist', function()
      assert.equal(type(Map.draw), 'function')
    end)

    it('should draw the active map', function()
      local xml_mock = {
        parse = function()
          local parsed_xml = {
            '        <?xml version="1.0" encoding="UTF-8"?>\n        ',
            {
              {
                {
                  empty = 1,
                  label = 'image',
                  xarg = {
                    height = '512',
                    source = '../../img/general.png',
                    trans = 'ffffff',
                    width = '512'
                  }
                },
                label = 'tileset',
                xarg = {
                  columns = '16',
                  firstgid = '1',
                  name = 'general',
                  tilecount = '256',
                  tileheight = '32',
                  tilewidth = '32'
                }
              },
              {
                {
                  {
                    empty = 1,
                    label = 'tile',
                    xarg = {
                      gid = '1'
                    }
                  },
                  {
                    empty = 1,
                    label = 'tile',
                    xarg = {
                      gid = '2'
                    }
                  },
                  {
                    empty = 1,
                    label = 'tile',
                    xarg = {
                      gid = '17'
                    }
                  },
                  {
                    empty = 1,
                    label = 'tile',
                    xarg = {
                      gid = '18'
                    }
                  },
                  label = 'data',
                  xarg = {}
                },
                label = 'layer',
                xarg = {
                  height = '2',
                  name = 'Tile Layer 1',
                  width = '2'
                }
              },
              label = 'map',
              xarg = {
                height = '2',
                nextobjectid = '1',
                orientation = 'orthogonal',
                renderorder = 'right-down',
                tileheight = '32',
                tilewidth = '32',
                version = '1.0',
                width = '2'
              }
            }
          }
          return parsed_xml
        end
      }
      package.loaded['src/services/xml'] = xml_mock

      spy.on(Love.graphics, 'draw')

      Map.load('foo')
      Map.draw()
      -- 4 tiles to draw
      assert.spy(Love.graphics.draw).called(4)
      assert.spy(Love.graphics.draw).called_with(match._, match._, 0, 0)

      package.loaded['src/services/xml'] = nil
    end)
  end)

  describe('unload', function()
    it('should exist', function()
      assert.equal(type(Map.unload), 'function')
    end)

    it('should assert a valid map name is given', function()
      assert.errors(function()
        Map.unload('foobar')
      end)
    end)
  end)

end)
