module.exports = class AbstractEntity
  constructor: () ->
    throw 'Abstract Class Entity cannot be instantiated'

  setEnv: (@env) ->
    return

  getEnv: () ->
    return @env

  update: (dT) ->
    throw 'Abstract Class Entity must implement [update] method'