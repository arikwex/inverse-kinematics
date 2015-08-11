p2 = require('p2')
AbstractEntity = require('./AbstractEntity')
COLLISION = require('enum/collision')

DENSITY = 0.005

module.exports = class Skeleton extends AbstractEntity
  constructor: (options) ->
    { @x
      @y
      @angle
      @world
      @width
      @height } = options
    @_visualization = 'skeleton'
    @limbs = []
    @_linkTorsoToWorld()

  addLimb: (options) ->
    {limb, mountX, mountY} = options
    @limbs.push(limb)

    # Connect the first limb segment to the Skeleton
    firstSegment = limb.getFirstSegment()
    if (firstSegment != null)
      joint = new p2.RevoluteConstraint(@body, firstSegment.body, {
        localPivotA:[mountX, mountY]
        localPivotB:[-firstSegment.width / 2.0, 0]
      })
      @world.addConstraint(joint);

    # Smart-Positioning of all limb segments
    limb.smartPositioning(@x + mountX, @y + mountY)
    return

  _linkTorsoToWorld: () ->
    @body = new p2.Body({
      mass: @width * @height * DENSITY
      position: [@x, @y]
    })
    torso = new p2.Box({
      width: @width
      height: @height
      collisionGroup: COLLISION.MUSCLE
      collisionMask: COLLISION.GROUND | COLLISION.MUSCLE
    })
    @body.addShape(torso)
    @world.addBody(@body)
    return

  update: (dT) ->
    for limb in @limbs
      limb.update(dT)
    return

  getX: () ->
    return @body.position[0]

  getY: () ->
    return @body.position[1]

  getAngle: () ->
    return @body.angle
###
if window.lowerArm
  q = (lowerArm.angle - (-2.4)) * window.Q
  lowerArm.applyForceLocal(p2.vec2.fromValues(0, q), p2.vec2.fromValues(-90, 0))
  lowerArm.applyForceLocal(p2.vec2.fromValues(0, -q), p2.vec2.fromValues(-110, 0))
if window.upperArm
  w = (upperArm.angle - (0.0)) * window.W
  upperArm.applyForceLocal(p2.vec2.fromValues(0, w), p2.vec2.fromValues(-90, 0))
  upperArm.applyForceLocal(p2.vec2.fromValues(0, -w), p2.vec2.fromValues(-110, 0))
###