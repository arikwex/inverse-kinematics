Renderer = require('renderer')

module.exports = {
  render: (self, gfx, skeleton) ->
    angle = skeleton.getAngle()
    x = skeleton.getX()
    y = skeleton.getY()
    cos = Math.cos(angle)
    sin = Math.sin(angle)
    gfx.setTransform(cos, sin, -sin, cos, x, y)

    gfx.strokeStyle = '#f44'
    gfx.beginPath()
    gfx.lineWidth = 2
    gfx.rect(-skeleton.width / 2.0, -skeleton.height / 2.0, skeleton.width, skeleton.height)
    gfx.stroke()

    for limb in skeleton.limbs
      self.render(gfx, limb)
    return
}