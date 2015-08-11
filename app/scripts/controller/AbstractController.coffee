module.exports = class AbstractController
  constructor: () ->
    throw 'Abstract Class Controller cannot be instantiated'

  step: (desired, observer, dT) ->
    throw 'Abstract Class Controller must implement [step] method'