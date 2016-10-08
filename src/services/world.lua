local Love = require 'src/services/love'

--- Set pixels per unit of length
local meter = 32 -- (base tile size)
Love.physics.setMeter(meter)

--- Create world gravity.
-- @int x-axis gravity
-- @int y-axis gravity
-- @string skip sleeping entities
local world = Love.physics.newWorld(0, 0, true)

return world
