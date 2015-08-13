$ = require('jquery')
Frame = require('./view/Frame')
Environment = require('./model/Environment')

ArmMachine = require('./model/machines/ArmMachine')

# Create Canvas
frame = new Frame()

# Create environment for physics & entities
env = new Environment()
world = env.getWorld()

# Create a Skeletal model with Limbs
armMachine = new ArmMachine({
  world: world
  x: 500
  y: 400
  angle: -0.3
  width: 150
  height: 40
})
env.addEntity(armMachine)

# Add the environment to the frame and attach it to the DOM
frame.setEnvironment(env)
$('app-body').append(frame.$el)

# Global hooks for debugging
window.frame = frame
window.animation = require('animation')
window.p2 = require('p2')
window.ENUM = require('enum')
window.$ = $