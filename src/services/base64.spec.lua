describe('services/xml', function()

  local Base64 = require 'src/services/base64'

  describe('decode', function()
    it('should exist', function()
      assert.equal(type(Base64.decode), 'function')
    end)

    it('should assert a string is given', function()
      local input = { 'aGVsbG8gd29ybGQh' }
      assert.errors(function()
        Base64.decode(input)
      end)
    end)

    it('should decode a string from base64', function()
      local input = 'aGVsbG8gd29ybGQh'
      local expectation = 'hello world!'
      assert.equal(Base64.decode(input), expectation)
    end)
  end)

  describe('encode', function()
    it('should exist', function()
      assert.equal(type(Base64.encode), 'function')
    end)

    it('should assert a string is given', function()
      local input = { 'hello world!' }
      assert.errors(function()
        Base64.encode(input)
      end)
    end)

    it('should encode a string into base64', function()
      local input = 'hello world!'
      local expectation = 'aGVsbG8gd29ybGQh'
      assert.equal(Base64.encode(input), expectation)
    end)
  end)

end)
