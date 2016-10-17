--- MoveRight

local begin = function(entity)
  entity.input.right = true
end

local finish = function(entity)
  entity.input.right = false
end

return {
  begin = begin,
  finish = finish
}
