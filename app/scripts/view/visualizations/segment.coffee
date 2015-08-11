module.exports = {
  render: (self, gfx, segment) ->
    angle = segment.getAngle()
    x = segment.getX()
    y = segment.getY()
    muscleStart = segment.getMuscleStart()
    muscleLength = segment.getMuscleLength()
    cos = Math.cos(angle)
    sin = Math.sin(angle)
    gfx.setTransform(cos, sin, -sin, cos, x, y)

    gfx.strokeStyle = '#fff'
    gfx.beginPath()
    gfx.lineWidth = 1
    gfx.moveTo(-segment.width / 2.0, 0)
    gfx.lineTo(segment.width / 2.0, 0)
    gfx.stroke()

    gfx.strokeStyle = '#f44'
    gfx.beginPath()
    gfx.lineWidth = 2
    gfx.rect(muscleStart, -segment.height / 2.0, muscleLength, segment.height)
    gfx.stroke()
    return
}