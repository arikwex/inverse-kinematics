class KinematicsEngine
  constructor: () ->
    return

  solve: (options) ->
    { @model
      @startPose
      @endPose
      @iterations
      @method } = options

    @method = @method || 'Newton-Raphson'
    @iterations = @iterations || 10
    return [0, -1.57, 1.57]

module.exports = new KinematicsEngine()