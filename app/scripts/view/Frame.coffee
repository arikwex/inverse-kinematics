$ = require('jquery')
animation = require('animation')
CanvasRenderer = require('./CanvasRenderer');

class Frame
  constructor: ->
    @initCanvas()
    @objects = []
    @world = null
    animation.addCallback((dT) => @animationCallback(dT))
    return

  initCanvas: ->
    $win = $(window)
    @width = $win.width()
    @height = $win.height()
    @$el = $('<canvas>')
    @$el.addClass('view-panel')
    @$el.attr('width', @width)
    @$el.attr('height', @height)
    @gfx = (@$el.get(0)).getContext('2d')
    return

  setWorld: (world) ->
    @world = world

  animationCallback: (dT) ->
    @update(dT)
    @render(@gfx)
    return

  update: (dT) ->
    if @world
      if window.lowerArm
        q = (lowerArm.angle - (-2.4)) * window.Q
        lowerArm.applyForceLocal(p2.vec2.fromValues(0, q), p2.vec2.fromValues(-90, 0))
        lowerArm.applyForceLocal(p2.vec2.fromValues(0, -q), p2.vec2.fromValues(-110, 0))
      if window.upperArm
        w = (upperArm.angle - (0.0)) * window.W
        upperArm.applyForceLocal(p2.vec2.fromValues(0, w), p2.vec2.fromValues(-90, 0))
        upperArm.applyForceLocal(p2.vec2.fromValues(0, -w), p2.vec2.fromValues(-110, 0))
      @world.step(dT)
    return

  render: (gfx) ->
    gfx.setTransform(1, 0, 0, 1, 0, 0)
    gfx.clearRect(0, 0, @width, @height)
    if @world
      for body in @world.bodies
        CanvasRenderer.render(gfx, body)
    return


module.exports = Frame