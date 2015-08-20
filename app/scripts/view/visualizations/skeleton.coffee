COLLISION = require('enum/collision')

module.exports = {
  render: (self, gfx, skeleton) ->
    for limb in skeleton.limbs
      if limb.collisionGroup == COLLISION.MUSCLE_BACK2
        self.render(gfx, limb)
    for limb in skeleton.limbs
      if limb.collisionGroup == COLLISION.MUSCLE_BACK
        self.render(gfx, limb)

    for limb in skeleton.limbs
      if limb.collisionGroup == COLLISION.MUSCLE_MIDDLE
        self.render(gfx, limb)

    angle = skeleton.getAngle()
    x = skeleton.getX()
    y = skeleton.getY()
    cos = Math.cos(angle)
    sin = Math.sin(angle)
    gfx.setTransform(cos, sin, -sin, cos, x, y)

    txtr = skeleton.getTexture()
    if txtr != null and !self.WIREFRAME
      scaling_x = txtr.width / txtr.image.width
      scaling_y = txtr.height / txtr.image.height
      gfx.scale(scaling_x, scaling_y)
      gfx.drawImage(txtr.image, -txtr.width / 2.0 / scaling_x, -txtr.height / 2.0 / scaling_y)
    else
      gfx.strokeStyle = '#f44'
      gfx.beginPath()
      gfx.lineWidth = 2
      gfx.rect(-skeleton.width / 2.0, -skeleton.height / 2.0, skeleton.width, skeleton.height)
      gfx.stroke()

    for limb in skeleton.limbs
      if limb.collisionGroup == COLLISION.MUSCLE_FRONT
        self.render(gfx, limb)
    for limb in skeleton.limbs
      if limb.collisionGroup == COLLISION.MUSCLE_FRONT2
        self.render(gfx, limb)
    return
}