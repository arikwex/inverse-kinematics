p2 = require('p2')
COLLISION = require('enum/collision')

DENSITY = 0.001

module.exports = class Segment
  constructor: (options) ->
    { @startPadding
      @endPadding
      @width
      @height
      @world } = options
    @_visualization = 'segment'
    @_linkSegmentToWorld()
    return

  setPrevious: (@previous) ->
    return

  setNext: (@next) ->
    return

  _linkSegmentToWorld: () ->
    @body = new p2.Body({
      mass: @width * @height * DENSITY
      position: [500, 0]
    })
    @muscleLength = @width - (@startPadding + @endPadding)
    muscle = new p2.Box({
      width: @muscleLength
      height: @height
      collisionGroup: COLLISION.MUSCLE
      collisionMask: COLLISION.GROUND | COLLISION.MUSCLE
    })
    @body.addShape(muscle)
    muscle.position = [@startPadding / 2.0 - @endPadding / 2.0, 0]
    @world.addBody(@body)
    return

  getX: () ->
    return @body.position[0]

  getY: () ->
    return @body.position[1]

  getAngle: () ->
    return @body.angle

  getMuscleStart: () ->
    return -@width / 2.0 + @startPadding

  getMuscleLength: () ->
    return @muscleLength