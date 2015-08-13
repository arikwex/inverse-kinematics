p2 = require('p2')
AbstractEntity = require('./AbstractEntity')

module.exports = class Limb extends AbstractEntity
  constructor: (@world) ->
    @_visualization = 'limb'
    @segments = []
    return

  addSegment: (newSegment) ->
    # Chain segment references
    if (@segments.length > 0)
      previousSegment = @segments[@segments.length - 1]
      newSegment.setPrevious(previousSegment)
      previousSegment.setNext(newSegment)
      joint = new p2.RevoluteConstraint(previousSegment.body, newSegment.body, {
        localPivotA:[previousSegment.width / 2.0, 0]
        localPivotB:[-newSegment.width / 2.0, 0]
      })
      @world.addConstraint(joint);

    # Track the new segment
    @segments.push(newSegment)
    return @

  getFirstSegment: () ->
    if (@segments.length > 0)
      return @segments[0]
    return null

  smartPositioning: () ->
    startAngle = @skeleton.getAngle()
    C = Math.cos(startAngle)
    S = Math.sin(startAngle)
    startX = @skeleton.getX() + C * @mountX - S * @mountY
    startY = @skeleton.getY() + S * @mountX + C * @mountY
    for segment in @segments
      dA = segment.getAngle()
      startAngle += dA
      dX = Math.cos(startAngle) * segment.width
      dY = Math.sin(startAngle) * segment.width
      segment.body.position[0] = startX + dX * 0.5
      segment.body.position[1] = startY + dY * 0.5
      segment.body.angle = startAngle
      startX += dX
      startY += dY
    return

  setSkeleton: (@skeleton) ->
    firstSegment = @.getFirstSegment()
    if firstSegment
      firstSegment.setPrevious(@skeleton)
    return

  setMountingPoint: (@mountX, @mountY) ->
    return

  update: (dT) ->
    for segment in @segments
      segment.update(dT)
    return
