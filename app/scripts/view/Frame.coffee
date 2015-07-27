$ = require 'jquery'
animation = require 'animation'

class Frame
  constructor: ->
    @initCanvas()
    @objects = []
    animation.addCallback @animationCallback.bind @
    return

  initCanvas: ->
    $win = $(window)
    @width = $win.width()
    @height = $win.height()
    @$el = $('<canvas>')
    @$el.addClass 'view-panel'
    @$el.attr 'width', @width
    @$el.attr 'height', @height
    @gfx = (@$el.get 0).getContext '2d'
    return

  animationCallback: (dT) ->
    @update dT
    @render(@gfx)
    return

  update: (dT) ->
    return

  render: (gfx) ->
    gfx.clearRect 0, 0, @width, @height
    gfx.strokeStyle = 'white'
    gfx.beginPath()
    gfx.moveTo 100, 100
    gfx.lineTo 200, 200
    gfx.stroke()
    return


module.exports = Frame