-- Args service
-- Parse and store boot-time arguments

local args = {}

local get_arg = function(key)
  if args[key] then
    return args[key]
  end
  return false
end

-- This will likely be expanded later to take argument-parameter
-- pairs, for instance, to set window dimensions or draw scaling.
local load = function(raw_args)
  for _, arg in ipairs(raw_args) do
    args[arg] = true
  end
end

return {
  get_arg = get_arg,
  load = load
}
