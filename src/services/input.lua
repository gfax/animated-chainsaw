--- Input service
-- Store and process callbacks for input actions

local KeyPresses = {}
local KeyReleases = {}

local call_key_press = function(pressed_key)
  local key_function = KeyPresses[pressed_key]

  if (key_function) then
    key_function()
  end
end

local call_key_release = function(released_key)
  local key_function = KeyReleases[released_key]

  if (key_function) then
    key_function()
  end
end

local register_key_press = function(key, func)
  KeyPresses[key] = func
  return func
end

local register_key_release = function(key, func)
  KeyReleases[key] = func
  return func
end

return {
  call_key_press = call_key_press,
  call_key_release = call_key_release,
  register_key_press = register_key_press,
  register_key_release = register_key_release
}
