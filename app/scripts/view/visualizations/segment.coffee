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

    txtr = segment.getTexture()
    if txtr != null and !self.WIREFRAME
      scaling_x = txtr.width / txtr.image.width
      scaling_y = txtr.height / txtr.image.height
      gfx.scale(scaling_x, scaling_y)
      gfx.drawImage(txtr.image, -txtr.width / 2.0 / scaling_x + txtr.offsetX, -txtr.height / 2.0 / scaling_y + txtr.offsetY)
    else
      gfx.strokeStyle = '#000'
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