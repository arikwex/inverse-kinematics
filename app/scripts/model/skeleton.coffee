AbstractEntity = require('./AbstractEntity')

module.exports = class Skeleton extends AbstractEntity
  constructor: (options) ->
    { @x
      @y
      @angle
      @vx
      @vy
      @omega } = options
    @limbs = []

  addLimb: (options) ->
    {limb, mountX, mountY} = options
    @limbs.push(limb)

  update: (dT) ->
    for limb in @limbs
      limb.update(dT)
    return

  render: (gfx) ->
    @renderTorso(gfx)
    for limb in @limbs
      limb.render(gfx)
    return

  renderTorso: (gfx) ->
    # TODO
    return

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