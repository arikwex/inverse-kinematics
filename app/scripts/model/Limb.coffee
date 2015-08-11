p2 = require('p2')

module.exports = class Limb
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

  smartPositioning: (startX, startY) ->
    for segment in @segments
      dX = Math.cos(segment.getAngle()) * segment.width
      dY = Math.sin(segment.getAngle()) * segment.width
      segment.body.position[0] = startX + dX * 0.5
      segment.body.position[1] = startY + dY * 0.5
      startX += dX
      startY += dY
    return

  update: (dT) ->
    for segment in @segments
      segment.update(dT)
    return
