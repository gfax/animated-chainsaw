function loadmap()
  TilesetEx = love.graphics.newImage("images/countryside.png")
  TilesetGen = love.graphics.newImage("images/General.png")

  tileWEx, tileHEx = 32,32
  local tilesetWEx, tilesetHEx = TilesetEx:getWidth(), TilesetEx:getHeight()
  tileWGen, tileHGen = 32,32
  local tilesetWGen, tilesetHGen = TilesetGen:getWidth(), TilesetGen:getHeight()

  Quads = {
    ["%1"] = love.graphics.newQuad(0,  0, tileWEx, tileHEx, tilesetWEx, tilesetHEx), -- 1 old grass
    ["%2"] = love.graphics.newQuad(32, 0, tileWEx, tileHEx, tilesetWEx, tilesetHEx), -- 2 old flower
    ["%3"] = love.graphics.newQuad(0, 32, tileWEx, tileHEx, tilesetWEx, tilesetHEx), -- 3 old box
    ["%4"] = love.graphics.newQuad(32, 32, tileWEx, tileHEx, tilesetWEx, tilesetHEx), -- 4 old box panel

    ["."] = love.graphics.newQuad(32, 352, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- . Grass .

    ["#_<"] = love.graphics.newQuad(448, 0, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- #_< Small Stall Left
    ["#_>"] = love.graphics.newQuad(480, 0, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- #_> Small Stall Right
    ["#%<"] = love.graphics.newQuad(448, 32, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- #%< Fruit Stall Left
    ["#%>"] = love.graphics.newQuad(480, 32, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- #%> Fruit Stall Right

    ["*"] = love.graphics.newQuad(32, 32, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- * Cobble *
    ["*<^"] = love.graphics.newQuad(0, 0, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- *<^ Top Left Cobble
    ["*^"] = love.graphics.newQuad(32, 0, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- *^ Top Cobble
    ["*<"] = love.graphics.newQuad(0, 32, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- *< Left Cobble
    ["*>^"] = love.graphics.newQuad(64, 0, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- *>^ Top Right Cobble
    ["*>"] = love.graphics.newQuad(64, 32, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- *> Right Cobble
  }

  TileTable = {
    {  ".",  "#_<",  "#_>",  "." },
    { "*<^",  "#%<",  "#%>", "*>^" },
    { "*<", "*", "*", "*>" }
  }

end

function drawmap()
  for rowIndex, rowValue in ipairs(TileTable) do
    for tileIndex, tileValue  in ipairs(rowValue) do
      local x = (tileIndex - 1) * tileWGen
      local y = (rowIndex - 1) * tileHGen
      love.graphics.draw(TilesetGen, Quads[tileValue], x, y)
    end
  end
end
