describe('services/map', function()

  local Love
  local path = 'src/services/map'

  -- Mock Entity dependency
  before_each(function()
    local entity_mock = {
      list = {},
      spawn = function() end
    }
    package.loaded['src/services/entity'] = entity_mock
  end)
  after_each(function()
    package.loaded['src/services/entity'] = nil
  end)

  -- Mock Love dependency
  before_each(function()
    local love_mock = {
      filesystem = {
        getDirectoryItems = function()
          return { 'foo.tmx', 'foo.bar', 'tmx.fake' }
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
        newQuad = function()
        end,
        polygon = function()
          return true
        end,
        setColor = function()
          return true
        end
      },
      physics = {
        newBody = function()
          return 'body'
        end,
        newFixture = function(body, shape)
          return {
            body = body,
            getBody = function()
              return body
            end,
            getShape = function()
              return shape
            end,
            setGroupIndex = function() end,
            shape = shape
          }
        end,
        newPolygonShape = function()
          return 'polygon'
        end,
        newRectangleShape = function()
          return 'rectangle'
        end
      }
    }
    package.loaded['src/services/love'] = love_mock
    Love = love_mock
  end)
  after_each(function()
    package.loaded['src/services/love'] = nil
  end)

  -- Mock World dependency
  before_each(function()
    local world_mock = {}
    package.loaded['src/services/world'] = world_mock
  end)
  after_each(function()
    package.loaded['src/services/world'] = nil
  end)

  -- Tear down loaded modules
  after_each(function()
    package.loaded['src/services/args'] = nil
    package.loaded['src/services/map'] = nil
    package.loaded['src/services/tmx'] = nil
  end)

  describe('load', function()
    it('should exist', function()
      local service = require(path)
      assert.equal(type(service.load), 'function')
    end)

    it('should assert a valid map name is given', function()
      local service = require(path)
      assert.errors(function()
        service.load('foobar')
      end)
    end)

    it('should load images and quads from parsed tmx content', function()
      package.loaded['src/services/love'].graphics.newQuad = function(tile_x, tile_y, tile_w, tile_h, img_w, img_h)
        return {
          tile_x = tile_x,
          tile_y = tile_y,
          tile_w = tile_w,
          tile_h = tile_h,
          img_w = img_w,
          img_h = img_h
        }
      end
      local tmx_mock = {
        parse = function()
          return {
            columns = 2,
            layers = {
              {
                data = { 1, 2, 17, 18 },
                height = '2',
                pos_x = 0,
                pos_y = 0,
                width = '2'
              }
            },
            orientation = 'orthogonal',
            render_order = 'right-down',
            rows = 2,
            tile_height = 32,
            tile_width = 32,
            tilesets = {
              {
                columns = 16,
                first_gid = 1,
                source = 'img/general.png',
                tile_count = 256,
                tile_height = 32,
                tile_width = 32,
                transparency = 'ffffff'
              }
            }
          }
        end
      }
      package.loaded['src/services/tmx'] = tmx_mock
      local service = require(path)

      spy.on(Love.graphics, 'newQuad')

      local results = service.load('foo')

      assert.equal(results.columns, 2)
      assert.equal(#results.quads, 256)

      assert.spy(Love.graphics.newQuad).called(256)
    end)

    it('should load fixtures from parsed tmx content', function()
      local tmx_mock = {
        parse = function()
          return {
            columns = 2,
            layers = {
              {
                objects = {
                  {
                    crazy = 'definitely',
                    height = 32,
                    name = 'lil grass box',
                    pos_x = 32,
                    pos_y = 32,
                    type = 'cute',
                    width = 32
                  },
                  {
                    name = 'Triangle',
                    points = { 0, 0, 96, 96, 0, 96 },
                    pos_x = 608,
                    pos_y = 128
                  }
                },
                type = 'objects'
              }
            },
            orientation = 'orthogonal',
            render_order = 'right-down',
            rows = 2,
            tile_height = 32,
            tile_width = 32,
            tilesets = {
              columns = 1,
              first_gid = 1,
              source = 'img/general.png',
              tile_count = 1,
              tile_height = 1,
              tile_width = 1,
              transparency = 'ffffff'
            }
          }
        end
      }
      package.loaded['src/services/tmx'] = tmx_mock

      local service = require(path)

      spy.on(Love.physics, 'newBody')
      spy.on(Love.physics, 'newPolygonShape')
      spy.on(Love.physics, 'newRectangleShape')

      local results = service.load('foo')

      assert.equal(type(results.layers), 'table')
      assert.equal(#results.layers, 1)

      local layer1 = results.layers[1]
      assert.equal(type(layer1), 'table')
      assert.equal(type(layer1.objects), 'table')
      assert.equal(#layer1.objects, 2)

      local fixture1 = layer1.objects[1]
      assert.equal(fixture1.body, 'body')
      assert.equal(fixture1.shape, 'rectangle')
      local fixture2 = layer1.objects[2]
      assert.equal(fixture2.body, 'body')
      assert.equal(fixture2.shape, 'polygon')

      assert.spy(Love.physics.newBody).called(2)
      assert.spy(Love.physics.newPolygonShape).called(1)
      assert.spy(Love.physics.newPolygonShape).called_with({ 0, 0, 96, 96, 0, 96 })
      assert.spy(Love.physics.newRectangleShape).called(1)
      assert.spy(Love.physics.newRectangleShape).called_with(16, 16, 32, 32)

      package.loaded['src/services/entity'] = nil
    end)
  end)

  describe('draw', function()
    it('should exist', function()
      local service = require(path)
      assert.equal(type(service.draw), 'function')
    end)

    it('should draw the active map', function()
      local tmx_mock = {
        parse = function()
          return {
            columns = 2,
            layers = {
              {
                data = { 1, 2, 17, 18 },
                height = '2',
                pos_x = 0,
                pos_y = 0,
                type = 'tiles',
                width = '2'
              }
            },
            orientation = 'orthogonal',
            render_order = 'right-down',
            rows = 2,
            tile_height = 32,
            tile_width = 32,
            tilesets = {
              {
                columns = 16,
                first_gid = 1,
                source = 'img/general.png',
                tile_count = 256,
                tile_height = 32,
                tile_width = 32,
                transparency = 'ffffff'
              }
            }
          }
        end
      }
      package.loaded['src/services/tmx'] = tmx_mock
      local service = require(path)

      spy.on(Love.graphics, 'draw')

      service.load('foo')
      service.draw()
      -- 4 tiles to draw
      assert.spy(Love.graphics.draw).called(4)
      assert.spy(Love.graphics.draw).called_with(match._, match._, 0, 0)
      assert.spy(Love.graphics.draw).called_with(match._, match._, 32, 0)
      assert.spy(Love.graphics.draw).called_with(match._, match._, 0, 32)
      assert.spy(Love.graphics.draw).called_with(match._, match._, 32, 32)
    end)

    it('should draw fixtures on the active map in debug mode', function()
      package.loaded['src/services/love'].physics.newBody = function(_, pos_x, pos_y)
        local x = pos_x
        local y = pos_y
        return {
          getWorldPoints = function()
            return { x, y }
          end
        }
      end
      package.loaded['src/services/love'].physics.newPolygonShape = function()
        return {
          getPoints = function()
            return true
          end
        }
      end
      package.loaded['src/services/love'].physics.newRectangleShape = function()
        return {
          getPoints = function()
            return true
          end
        }
      end
      local args_mock = {
        get_arg = function()
          return true
        end
      }
      package.loaded['src/services/args'] = args_mock
      local tmx_mock = {
        parse = function()
          return {
            columns = 2,
            layers = {
              {
                objects = {
                  {
                    crazy = 'definitely',
                    height = 32,
                    name = 'lil grass box',
                    pos_x = 32,
                    pos_y = 32,
                    type = 'cute',
                    width = 32
                  },
                  {
                    name = 'Triangle',
                    points = { 0, 0, 96, 96, 0, 96 },
                    pos_x = 608,
                    pos_y = 128
                  }
                },
                type = 'objects'
              }
            },
            orientation = 'orthogonal',
            render_order = 'right-down',
            rows = 2,
            tile_height = 32,
            tile_width = 32,
            tilesets = {
              columns = 16,
              first_gid = 1,
              source = 'img/general.png',
              tile_count = 256,
              tile_height = 32,
              tile_width = 32,
              transparency = 'ffffff'
            }
          }
        end
      }
      package.loaded['src/services/tmx'] = tmx_mock
      local service = require(path)

      spy.on(Love.graphics, 'polygon')

      service.load('foo')
      service.draw()
      assert.spy(Love.graphics.polygon).called(2)
    end)
  end)

  describe('unload', function()
    it('should exist', function()
      local service = require(path)
      assert.equal(type(service.unload), 'function')
    end)

    it('should assert a valid map name is given', function()
      local service = require(path)
      assert.errors(function()
        service.unload('foobar')
      end)
    end)
  end)

end)
