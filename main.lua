function loadmap()
	TilesetEx = love.graphics.newImage("images/countryside.png")
	TilesetGen = love.graphics.newImage("images/General.png")

	tileWEx, tileHEx = 32,32
	local tilesetWEx, tilesetHEx = TilesetEx:getWidth(), TilesetEx:getHeight()
	tileWGen, tileHGen = 32,32
  local tilesetWGen, tilesetHGen = TilesetGen:getWidth(), TilesetGen:getHeight()

  Quads = {
  	GrassQuad = love.graphics.newQuad(0,  0, tileWEx, tileHEx, tilesetWEx, tilesetHEx), -- old
    BoxQuad = love.graphics.newQuad(32, 0, tileWEx, tileHEx, tilesetWEx, tilesetHEx), -- old
    FlowerQuad = love.graphics.newQuad(0, 32, tileWEx, tileHEx, tilesetWEx, tilesetHEx), -- old
    WoodpanelQuad = love.graphics.newQuad(32, 32, tileWEx, tileHEx, tilesetWEx, tilesetHEx), -- old
  	GrassGenQuad = love.graphics.newQuad(32, 352, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- 5 Grass
  	SmStallLeftQuad = love.graphics.newQuad(448, 0, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- 6 Small Stall Left
  	SmStallRightQuad = love.graphics.newQuad(480, 0, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- 7 Small Stall Right
  	SmFruitStallLeftQuad = love.graphics.newQuad(448, 32, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- 8 Fruit Stall Left
  	SmFruitStallRightQuad = love.graphics.newQuad(480, 32, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- 9 Fruit Stall Right
  	TpLeftCobbleQuad = love.graphics.newQuad(0, 0, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- 10 Top Left Cobble
  	TpCobbleQuad = love.graphics.newQuad(32, 0, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- 11 Top Cobble
  	LeftCobbleQuad = love.graphics.newQuad(0, 32, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- 12 Left Cobble
  	CobbleQuad = love.graphics.newQuad(32, 32, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- 13 Cobble
  	TpRightCobbleQuad = love.graphics.newQuad(96, 0, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- 14 Top Right Cobble
  	RightCobbleQuad = love.graphics.newQuad(96, 32, tileWGen, tileHGen, tilesetWGen, tilesetHGen), -- 15 Right Cobble
  }

  TileTable = {

  	{ 5, 6, 7, 5},
  	{ 10, 8, 9, 14},
  	{ 12, 13, 13, 15}

	}

end

function drawmap()
	for rowIndex=1, #TileTable do
    local row = TileTable[rowIndex]
    for columnIndex=1, #row do
      local number = row[columnIndex]
      local x = (columnIndex-1)*tileWGen
      local y = (rowIndex-1)*tileHGen
			print("test")
			print(Quads[number])
      love.graphics.draw(TilesetGen, Quads[number], x, y)
    end
  end
end

function love.load()
	loadmap()
end

function love.draw()
  drawmap()
end
