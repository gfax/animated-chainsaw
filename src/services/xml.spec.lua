describe('services/xml', function()

  local Xml

  -- Reload service between tests
  before_each(function()
    Xml = require 'services/xml'
  end)

  describe('parse', function()
    it('should parse xml strings', function()
      local xml_string = [[
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

      local expected_table = {
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

      assert.same(Xml.parse(xml_string), expected_table)
    end)
  end)

end)
