--- Input service
-- Store and process callbacks for input actions

local press_callbacks = {}
local release_callbacks = {}

local call_key_press = function(pressed_key)
  local array = press_callbacks[pressed_key]

  if (array) then
    local i = 1
    while array[i] do
      if array[i].fn then
        array[i].fn(array[i].data)
      end
      i = i + 1
    end
  end
end

local call_key_release = function(released_key)
  local array = release_callbacks[released_key]

  if (array) then
    local i = 1
    while array[i] do
      if array[i].fn then
        array[i].fn(array[i].data)
      end
      i = i + 1
    end
  end
end

local register_key_press = function(key, fn, data)
  if not press_callbacks[key] then
    press_callbacks[key] = {}
  end
  table.insert(press_callbacks[key], {
    fn = fn,
    data = data
  })
  return fn
end

local register_key_release = function(key, fn, data)
  if not release_callbacks[key] then
    release_callbacks[key] = {}
  end
  table.insert(release_callbacks[key], {
    fn = fn,
    data = data
  })
  return fn
end

return {
  call_key_press = call_key_press,
  call_key_release = call_key_release,
  register_key_press = register_key_press,
  register_key_release = register_key_release
}
