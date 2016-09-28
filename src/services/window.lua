--- Window
-- Some constant variables calculated ahead of time.

local Love = require 'src/services/love'

local width, height = Love.graphics:getDimensions()

return {
  height = height,
  width = width
}
