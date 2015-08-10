p2 = require('p2')
Renderer = require('renderer')

module.exports = class Limb
  constructor: (@world) ->
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

  update: (dT) ->
    return

  render: (gfx) ->
    for segment in @segments
      Renderer.render(gfx, segment)
    return
