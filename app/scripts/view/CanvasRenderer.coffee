p2 = require('p2');

module.exports = {
  WIREFRAME: false

  visualizations: {
    'skeleton': require('./visualizations/skeleton')
    'limb': require('./visualizations/limb')
    'segment': require('./visualizations/segment')
  }

  render: (gfx, obj) ->
    if (obj._visualization)
      visualization = obj._visualization
      renderer = @visualizations[visualization]
      if (renderer)
        renderer.render(this, gfx, obj)
    return
}