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

$(window).mousedown((evt) ->
  part = frame.env.entities[0].limbs[10].segments[0].body
  angle = part.angle
  M = -10000
  part.applyImpulse(p2.vec2.fromValues(Math.cos(angle)*M, Math.sin(angle)*M), p2.vec2.fromValues(0,0))
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
    config: config
  })
  env.addEntity(spiderMachine)
  mostRecent = spiderMachine

# Default spider config
baseConfig = {
  femurAngle: 15
  tibiaAngle: -60
  tarsusAngle: 120
  tibiaSpan: 0.3
  tarsusSpan: 0.6
  tarsusPhase: 1.9
  gateSpeed: 4.5
}
generateSpider(baseConfig)

###
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