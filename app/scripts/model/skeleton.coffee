p2 = require('p2')
AbstractEntity = require('./AbstractEntity')
COLLISION = require('enum/collision')

DENSITY = 0.003

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
    @txtr = null

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
      firstSegment.setPreviousConstraint(joint)
      @world.addConstraint(joint);

    # Smart-Positioning of all limb segments
    limb.setSkeleton(@)
    limb.setMountingPoint(mountX, mountY)
    limb.smartPositioning()
    return limb

  removeLimb: (limbToRemove) ->
    indexToRemove = 0
    remove = false
    for limb in @limbs
      if limb == limbToRemove
        remove = true
        break
      indexToRemove++
    if remove
      @limbs.splice(indexToRemove, 1)
    return

  _linkTorsoToWorld: () ->
    @body = new p2.Body({
      mass: @width * @height * DENSITY
      position: [@x, @y]
      angle: @angle
    })
    torso = new p2.Box({
      width: @width
      height: @height
      collisionGroup: COLLISION.MUSCLE
      collisionMask: COLLISION.GROUND |
                     COLLISION.MUSCLE |
                     COLLISION.MUSCLE_FRONT |
                     COLLISION.MUSCLE_BACK
    })
    @body.addShape(torso)
    @world.addBody(@body)
    return

  update: (dT) ->
    for limb in @limbs
      limb.update(dT)
    return

  dispose: () ->
    while @limbs.length > 0
      @limbs[0].dispose()
    @world.removeBody(@body)
    @env.removeEntity(@)
    return

  getX: () ->
    return @body.position[0]

  getY: () ->
    return @body.position[1]

  getAngle: () ->
    return @body.angle

  disconnectNext: () ->
    return

  setTexture: (options) ->
    { width
      height
      src } = options
    @txtr = {
      image: new Image()
      width: width
      height: height
    }
    @txtr.image.src = src
    return

  getTexture: () ->
    return @txtr