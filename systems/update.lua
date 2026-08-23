local system = System(
  { 'update' },
  function (update, e, dt)
    assert(type(update) == 'function')
    update(e, dt)
  end
)

return system
