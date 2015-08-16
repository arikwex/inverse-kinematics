$ = require('jquery')
animation = require('animation')

class Frame
  constructor: ->
    @initCanvas()
    @env = null
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

  animationCallback: (dT) ->
    @update(dT)
    @render(@gfx)
    return

  update: (dT) ->
    if @env
      @env.update(dT)
    return

  render: (gfx) ->
    gfx.resetTransform()
    gfx.fillStyle = '#eee'
    gfx.fillRect(0, 0, @width, @height)
    if @env
      @env.render(gfx)
    return

  setEnvironment: (env) ->
    @env = env
    return

module.exports = Frame