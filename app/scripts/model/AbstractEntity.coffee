module.exports = class AbstractEntity
  constructor: () ->
    throw 'Abstract Class Entity cannot be instantiated'

  update: (dT) ->
    return

  render: (gfx) ->
    return