--- MoveDown

local begin = function(entity)
  entity.input.down = true
end

local finish = function(entity)
  entity.input.down = false
end

return {
  begin = begin,
  finish = finish
}
