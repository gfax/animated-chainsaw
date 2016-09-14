local copy
copy = function(orig)
  -- Primitive types: number, string, boolean, etc
  if type(orig) ~= 'table' then
    return orig
  end
  local new_table = {}
    for orig_key, orig_value in next, orig, nil do
      new_table[copy(orig_key)] = copy(orig_value)
    end
    setmetatable(new_table, copy(getmetatable(orig)))
  return new_table
end

return {
  copy = copy
}
