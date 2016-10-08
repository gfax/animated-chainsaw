describe('services/args', function()

  local service

  -- Tear down stateful service between tests
  before_each(function()
    service = require 'src/services/args'
  end)
  after_each(function()
    service = nil
    package.loaded['src/services/args'] = nil
  end)

  describe('load', function()
    it('should exist', function()
      assert.equal(type(service.load), 'function')
    end)

    it('should collect and return arguments', function()
      local args = { 'debug', 'foo' }
      service.load(args)
      assert.equal(service.get_arg('debug'), true)
      assert.equal(service.get_arg('foo'), true)
      assert.equal(service.get_arg('bar'), false)
    end)
  end)

end)
