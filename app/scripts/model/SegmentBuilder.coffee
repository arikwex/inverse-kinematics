Segment = require('./Segment')

module.exports = class SegmentBuilder
  constructor: (@world) ->
    @previous = null
    @next = null
    return

  build: () ->
    segment = new Segment({
      startPadding: @_startPadding
      endPadding: @_endPadding
      startAngle: @_angle
      controller: @_controller
      width: @_width
      height: @_height
      world: @world
    })
    return segment

  setController: (@_controller) ->
    return @

  setAngle: (@_angle) ->
    return @

  startPadding: (@_startPadding) ->
    return @

  endPadding: (@_endPadding) ->
    return @

  bodySize: (@_width, @_height) ->
    return @