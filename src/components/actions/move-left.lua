--- MoveLeft

local begin = function(entity)
  entity.input.left = true
end

local finish = function(entity)
  entity.input.left = false
end

return {
  begin = begin,
  finish = finish
}
