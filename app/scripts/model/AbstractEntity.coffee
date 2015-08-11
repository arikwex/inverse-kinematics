module.exports = class AbstractEntity
  constructor: () ->
    throw 'Abstract Class Entity cannot be instantiated'

  update: (dT) ->
    throw 'Abstract Class Entity must implement [update] method'

  render: (gfx) ->
    throw 'Abstract Class Entity must implement [render] method'