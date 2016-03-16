function love.load()
	Tileset = love.graphics.newImage("images/countryside.png")

	local tileW, tileH = 32,32
	local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()

	GrassQuad = love.graphics.newQuad(0,  0, tileW, tileH, tilesetW, tilesetH)
  BoxQuad = love.graphics.newQuad(32, 0, tileW, tileH, tilesetW, tilesetH)
  FlowerQuad = love.graphics.newQuad(0, 32, tileW, tileH, tilesetW, tilesetH)
  WoodpanelQuad = love.graphics.newQuad(32, 32, tileW, tileH, tilesetW, tilesetH)
end



function love.draw()
	love.graphics.draw(Tileset, GrassQuad, 0, 0)
	love.graphics.draw(Tileset, FlowerQuad, 32, 0)
	love.graphics.draw(Tileset, FlowerQuad, 0, 32)
	love.graphics.draw(Tileset, WoodpanelQuad, 32, 32)
	love.graphics.draw(Tileset, FlowerQuad, 64, 32)
	love.graphics.draw(Tileset, FlowerQuad, 0, 64)
	love.graphics.draw(Tileset, FlowerQuad, 64, 64)
	love.graphics.draw(Tileset, GrassQuad, 64, 0)
	love.graphics.draw(Tileset, GrassQuad, 64, 96)
	love.graphics.draw(Tileset, GrassQuad, 0, 96)
	love.graphics.draw(Tileset, BoxQuad, 32, 64)
	love.graphics.draw(Tileset, FlowerQuad, 32, 96)

	love.graphics.draw(Tileset, GrassQuad, 368, 268)
	love.graphics.draw(Tileset, GrassQuad, 400, 268)
  love.graphics.draw(Tileset, GrassQuad, 432, 268)
  love.graphics.draw(Tileset, GrassQuad, 368, 300)
  love.graphics.draw(Tileset, BoxQuad  , 400, 300)
  love.graphics.draw(Tileset, GrassQuad, 432, 300)
  love.graphics.draw(Tileset, GrassQuad, 368, 332)
  love.graphics.draw(Tileset, GrassQuad, 400, 332)
  love.graphics.draw(Tileset, GrassQuad, 432, 332)
end
