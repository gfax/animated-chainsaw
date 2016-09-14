describe('services/util', function()

  local Util

  before_each(function()
    Util = require 'services/util'
  end)

  describe('copy', function()
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

end)
