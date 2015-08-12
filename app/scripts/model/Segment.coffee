p2 = require('p2')
COLLISION = require('enum/collision')
PIDController = require('controller/PIDController')

DENSITY = 0.001

module.exports = class Segment
  constructor: (options) ->
    { @startPadding
      @endPadding
      @startAngle
      @controller
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
      angle: @startAngle * (Math.PI / 180.0)
      position: [500, 500],
      angularDamping: 0.99
      damping: 0.99
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

  update: (dT) ->
    if @controller
      torque = @controller.step(@desiredAngle, @getAngle(), dT)
      @applyTorque(torque)
    return

  applyTorque: (magnitude) ->
    @body.angularForce += magnitude * 1000
    return

  setDesiredAngle: (@desiredAngle) ->
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