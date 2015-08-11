p2 = require('p2')
COLLISION = require('enum/collision')
PIDController = require('controller/PIDController')

DENSITY = 0.001

module.exports = class Segment
  constructor: (options) ->
    { @startPadding
      @endPadding
      @startAngle
      @width
      @height
      @world } = options
    @_visualization = 'segment'
    @_linkSegmentToWorld()
    @_controller = new PIDController({
      Kp: 1300 * @width
      Ki: 120 * @height
      Kd: -500 * @height
      maxGain: 500000
      maxAccumulated: 200
    })
    return

  setPrevious: (@previous) ->
    return

  setNext: (@next) ->
    return

  _linkSegmentToWorld: () ->
    @body = new p2.Body({
      mass: @width * @height * DENSITY
      angle: @startAngle * (Math.PI / 180.0)
      position: [500, 500]
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
    if window.ALLOW
      torque = @_controller.step(window.DANGLE, @getAngle(), dT)
      @applyTorque(torque)
    return

  applyTorque: (magnitude) ->
    @body.applyForceLocal(p2.vec2.fromValues(0, magnitude), p2.vec2.fromValues(-@width / 2.0 - 10, 0))
    @body.applyForceLocal(p2.vec2.fromValues(0, -magnitude), p2.vec2.fromValues(-@width / 2.0 + 10, 0))
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