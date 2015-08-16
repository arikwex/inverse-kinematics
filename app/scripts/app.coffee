$ = require('jquery')
Frame = require('./view/Frame')
Environment = require('./model/Environment')

SpiderMachine = require('./model/machines/SpiderMachine')

# Create Canvas
frame = new Frame()

# Create environment for physics & entities
env = new Environment()
world = env.getWorld()

# Create a Skeletal model with Limbs
spiderMachine = new SpiderMachine({
  world: world
  x: 300
  y: 400
  angle: 0.0
  width: 110
  height: 60
})
env.addEntity(spiderMachine)

# TUNER


# Add the environment to the frame and attach it to the DOM
frame.setEnvironment(env)
$('app-body').append(frame.$el)

# Global hooks for debugging
window.frame = frame
window.animation = require('animation')
window.p2 = require('p2')
window.ENUM = require('enum')
window.$ = $