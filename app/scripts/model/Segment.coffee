p2 = require('p2')
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
    @desiredAngle = @startAngle * Math.PI / 180.0
    @begin = 0
    @powered = true
    @next = null
    @previous = null
    return

  setPrevious: (@previous) ->
    return

  setNext: (@next) ->
    return

  setPreviousConstraint: (@previousConstraint) ->
    return

  setNextConstraint: (@nextConstraint) ->
    return

  setLimb: (@limb) ->
    return

  powerDown: () ->
    @powered = false
    if @next != null
      @next.powerDown()
    return

  disconnectPrevious: () ->
    if @previousConstraint != null
      @powerDown()
      @world.removeConstraint(@previousConstraint)
      @previousConstraint = null
      if @previous
        @previous.disconnectNext()
    return

  disconnectNext: () ->
    if @nextConstraint != null
      @powerDown()
      @world.removeConstraint(@nextConstraint)
      @nextConstraint = null
      if @next
        @next.disconnectPrevious()
    return

  dispose: () ->
    @disconnectPrevious()
    @disconnectNext()
    @world.removeBody(@body)
    @limb.removeSegment(@)
    @body = null
    return

  setCollisionGroup: (group) ->
    for shape in @body.shapes
      shape.collisionGroup = group
    return

  setCollisionMask: (mask) ->
    for shape in @body.shapes
      shape.collisionMask = mask
    return

  _linkSegmentToWorld: () ->
    @body = new p2.Body({
      mass: @width * @height * DENSITY
      angle: @startAngle * (Math.PI / 180.0)
      position: [0, 0],
      angularDamping: 0.2
      damping: 0.2
    })
    @muscleLength = @width - (@startPadding + @endPadding)
    muscle = new p2.Box({
      width: @muscleLength
      height: @height
    })
    @body.addShape(muscle)
    muscle.position = [@startPadding / 2.0 - @endPadding / 2.0, 0]
    muscle.material = window.MUSCLE
    @world.addBody(@body)
    return

  update: (dT) ->
    if @controller and @begin > 0.2 and @powered
      desired = @desiredAngle
      observed = @getRelativeAngle()
      diff = @wrapDiff(desired - observed)
      torque = @controller.step(diff, 0, dT)
      @applyTorque(torque)
    else
      @begin += dT
    return

  applyTorque: (magnitude) ->
    @body.angularForce += magnitude * 1000
    return

  wrapDiff: (a) ->
    while a > Math.PI
      a -= Math.PI
    while a < -Math.PI
      a += Math.PI
    return a

  getRelativeAngle: () ->
    if @previous
      return @getAngle() - @previous.getAngle()
    return @getAngle()

  setDesiredAngle: (@desiredAngle) ->
    return

  getDesiredAngle: () ->
    return @desiredAngle

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