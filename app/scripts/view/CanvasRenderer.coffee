p2 = require('p2');

module.exports = {
  visualizations: {
    'segment': require('./visualizations/segment')
  }

  render: (gfx, obj) ->
    if (obj._visualization)
      visualization = obj._visualization
      renderer = @visualizations[visualization]
      if (renderer)
        renderer.render(gfx, obj)
    return
}