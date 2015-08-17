_ = require('underscore')
$ = require('jquery')
Frame = require('./view/Frame')
Environment = require('./model/Environment')

SpiderMachine = require('./model/machines/SpiderMachine')

# Create Canvas
frame = new Frame()

window.MOUSE = {
  x: 0
  y: 0
}
$(window).mousemove((evt) ->
  window.MOUSE.x = evt.clientX
  window.MOUSE.y = evt.clientY
)

# Create environment for physics & entities
env = new Environment()
world = env.getWorld()

# Create a Skeletal model with Limbs
mostRecent = null
generateSpider = (config) ->
  if mostRecent != null
    mostRecent.dispose()
  spiderMachine = new SpiderMachine({
    world: world
    x: 300
    y: 400
    angle: 0.0
    width: 110
    height: 60
    config: config
  })
  env.addEntity(spiderMachine)
  mostRecent = spiderMachine

# Default spider config
baseConfig = {
  femurAngle: 25
  tibiaAngle: -60
  tarsusAngle: 100
  tibiaSpan: 0.25
  tarsusSpan: 0.5
  tarsusPhase: 1.9
  gateSpeed: 2.5
}
generateSpider(baseConfig)
###
baseConfig = {
  femurAngle: 24.42615076307438
  gateSpeed: 1.6282177221874918
  tarsusAngle: 142.79114308352214
  tarsusPhase: 1.4457514680190162
  tarsusSpan: 0.5152727080105194
  tibiaAngle: -71.79667999147192
  tibiaSpan: 0.6367783120112606
}

# Generate a config pool
configPool = []
mutateConfig = (config) ->
  result = {}
  gamma = Math.random() * 0.1
  if Math.random() > 0.7
    gamma = Math.random() * 0.6 + 0.1
  gamma = 0
  for key, value of config
    result[key] = value + (Math.random() - 0.5) * value * gamma + (Math.random() - 0.5) * gamma
  return result

configPool.push({
  params: _.extend({}, baseConfig)
  score: 300
})
for i in [0..5]
  configPool.push({
    params: mutateConfig(baseConfig)
    score: 300
  })

# Run genetic primitive Genetic Algorithm
testConfig = null
ANOTHER = () ->
  pickConfig = _.sample(configPool, 1)[0].params
  testConfig = mutateConfig(pickConfig)
  generateSpider(testConfig)

UPDATE_POOL = () ->
  if mostRecent != null and testConfig != null
    score = mostRecent.body.position[0] * Math.pow(Math.cos(mostRecent.body.angle), 5.0) / (1.0 + Math.abs(mostRecent.body.angularVelocity) * 0.3)
    for config in configPool
      if score > config.score
        console.log('+' + (score - config.score) + ' [' + score + ']', testConfig)
        config.params = testConfig
        config.score = score
        break
    configPool = _.sortBy(configPool, 'score')
  return

window.setInterval(() ->
  UPDATE_POOL()
  ANOTHER()
, 6000)

ANOTHER()
###

# Add the environment to the frame and attach it to the DOM
frame.setEnvironment(env)
$('app-body').append(frame.$el)

# Global hooks for debugging
window.frame = frame
window.animation = require('animation')
window.p2 = require('p2')
window.ENUM = require('enum')
window.$ = $
window._ = _