describe('services/util', function()

  local Util

  before_each(function()
    Util = require 'services/util'
  end)

  describe('copy', function()
    it('should exist', function()
      assert(type(Util.copy), 'function')
    end)

    it('should return copies of tables with keys', function()
      local a = { foo = 'bar' }
      local b = a
      local c = Util.copy(a)
      a.foo = 'baz'
      assert.equal(b.foo, 'baz')
      assert.equal(c.foo, 'bar')
    end)

    it('should return copies of tables with indexes', function()
      local a = { 'foo', 'bar' }
      local b = a
      local c = Util.copy(a)
      a[1] = 'baz'
      assert.equal(b[1], 'baz')
      assert.equal(c[1], 'foo')
    end)

    it('should return deep copies of tables', function()
      local a = {
        foo = {
          bar = {
            'baz'
          }
        }
      }
      local b = Util.copy(a)
      assert.same(a, b)
    end)

    it('should return strings', function()
      local str = 'Foobar123'
      assert.equal(Util.copy(str), 'Foobar123')
    end)

    it('should return integers', function()
      local int = 7
      assert.equal(Util.copy(int), 7)
    end)

    it('should return booleans', function()
      local bool = true
      assert.equal(Util.copy(bool), true)
    end)

    it('should return nils', function()
      assert.equal(Util.copy(nil), nil)
    end)
  end)

  describe('push', function()
    it('should exist', function()
      assert(type(Util.push), 'function')
    end)

    it('should modify the given table', function()
      local t = { 1, 2 }
      Util.push(t, 3)
      assert.equal(t[1], 1)
      assert.equal(t[2], 2)
      assert.equal(t[3], 3)
    end)

    it('should accept a list of elements to push', function()
      local t = { 1 }
      Util.push(t, 2, 3)
      assert.equal(t[1], 1)
      assert.equal(t[2], 2)
      assert.equal(t[3], 3)
    end)

    it('should ignore nil values', function()
      local t = { 1 }
      Util.push(t, nil, 2)
      assert.equal(t[1], 1)
      assert.equal(t[2], 2)
      assert.equal(t[3], nil)
    end)
  end)

  describe('split', function()
    it('should exist', function()
      assert(type(Util.copy), 'function')
    end)

    it('should split a string with the given separator', function()
      local str = 'foo-bar-baz'
      local expectation = { 'foo', 'bar', 'baz' }
      assert.same(Util.split(str, '-'), expectation)
      str = 'foo bar baz'
      assert.same(Util.split(str, ' '), expectation)
      str = 'foo%bar%baz'
      assert.same(Util.split(str, '%'), expectation)
      str = 'foo$bar$baz'
      assert.same(Util.split(str, '$'), expectation)
    end)

    it('should split a string with a multi-character separator', function()
      local str = 'foo%%%bar%%%baz'
      local expectation = { 'foo', 'bar', 'baz' }
      assert.same(Util.split(str, '%%%'), expectation)
    end)

    it('should default to a whitespace separator if none is given', function()
      local str = 'foo bar baz'
      local expectation = { 'foo', 'bar', 'baz' }
      assert.same(Util.split(str), expectation)
    end)

    it('should assert that the separator is at least one character', function()
      local str = 'foo bar baz'
      assert.errors(function()
        Util.split(str, '')
      end)
    end)
  end)

end)
