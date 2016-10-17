--- MoveUp

local begin = function(entity)
  entity.input.up = true
end

local finish = function(entity)
  entity.input.up = false
end

return {
  begin = begin,
  finish = finish
}
