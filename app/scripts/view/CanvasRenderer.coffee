p2 = require('p2');

module.exports = {
  render: (gfx, body) ->
    cos = Math.cos(body.angle)
    sin = Math.sin(body.angle)
    gfx.setTransform(cos, sin, -sin, cos, body.position[0], body.position[1])
    gfx.strokeStyle = 'white'
    for shape in body.shapes
      @.renderShape(gfx, shape)
    return

  renderShape: (gfx, shape) ->
    gfx.save()
    type = shape.type
    gfx.rotate(shape.angle)
    gfx.translate(shape.position[0], shape.position[1])
    if (type == p2.Shape.CIRCLE)
      gfx.beginPath()
      gfx.arc(0, 0, shape.radius, 0, 2 * Math.PI);
      gfx.stroke()
    else if (type == p2.Shape.CONVEX)
      gfx.beginPath()
      gfx.rect(-shape.width / 2.0, -shape.height / 2.0, shape.width, shape.height)
      gfx.stroke()
    gfx.restore()
    return
}