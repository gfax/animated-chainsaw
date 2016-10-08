describe('services/world', function()

  local Love

  -- Mock Love service
  before_each(function()
    package.loaded['src/services/love'] = {
      physics = {
        newWorld = function() end,
        setMeter = function() end
      }
    }
    Love = require 'src/services/love'
  end)
  after_each(function()
    Love = nil
    package.loaded['src/services/love'] = nil
  end)

  it('should set the meter when required', function()
    spy.on(Love.physics, 'setMeter')
    require 'src/services/world'
    assert.spy(Love.physics.setMeter).called(1)
    assert.spy(Love.physics.setMeter).called_with(32)
    package.loaded['src/services/world'] = nil
  end)

  it('should create a new world when required', function()
    spy.on(Love.physics, 'newWorld')
    require 'src/services/world'
    assert.spy(Love.physics.newWorld).called(1)
    assert.spy(Love.physics.newWorld).called_with(0, 0, true)
    package.loaded['src/services/world'] = nil
  end)

  it('should return the world', function()
    package.loaded['src/services/love'].physics.newWorld = function()
      return 'foo'
    end
    local service = require 'src/services/world'
    assert.equal(service, 'foo')
  end)

end)
