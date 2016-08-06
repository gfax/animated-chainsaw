--- UpdateEntityAnimation
-- Update entity animations I guess

local System = require 'lib/system'

local components = {
  'animation'
}

local system = function(animation, dt)
  animation:update(dt)
end

return System(components, system)
