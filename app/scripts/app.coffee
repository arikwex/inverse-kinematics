$ = require('jquery')
Frame = require('./view/Frame')
Environment = require('./model/Environment')

Skeleton = require('./model/Skeleton')
Limb = require('./model/Limb')
SegmentBuilder = require('./model/SegmentBuilder')

# Create Canvas
frame = new Frame()

# Create environment for physics & entities
env = new Environment()
world = env.getWorld()

# Create a Skeletal model with Limbs
BasicArm = new Skeleton({
  x: 0
  y: 0
  angle: 0
})
BasicArm.addLimb({
  limb: new Limb(world)
    .addSegment(new SegmentBuilder(world)
      .startPadding(20)
      .endPadding(20)
      .bodySize(100, 20)
      .build())
    .addSegment(new SegmentBuilder(world)
      .startPadding(30)
      .endPadding(0)
      .bodySize(100, 10)
      .build())
  mountX: 0
  mountY: 0
})
env.addEntity(BasicArm)

# Add the environment to the frame and attach it to the DOM
frame.setEnvironment(env)
$('app-body').append(frame.$el)

# Global hooks for debugging
window.frame = frame
window.animation = require('animation')
window.p2 = require('p2')
window.ENUM = require('enum')
window.$ = $


###
# Base
base = new p2.Body({
  mass: 3000
  position: [app.width / 2.0, app.height - 25]
})
base.addShape(new p2.Box({
  width: 200
  height: 50
  collisionGroup: SKELETON
  collisionMask: GROUND | OTHER
}))
world.addBody(base);

# LowerArm
lowerArm = new p2.Body({
  mass: 10
  position: [app.width / 2.0 + 100, app.height - 25]
})
lowerArm.addShape(new p2.Box({
  width: 200
  height: 30
  collisionGroup: SKELETON
  collisionMask: GROUND | OTHER
}))
world.addBody(lowerArm);
baseLowerArmJoint= new p2.RevoluteConstraint(base, lowerArm, {
  localPivotA:[0, 0]
  localPivotB:[-100, 0]
})
world.addConstraint(baseLowerArmJoint);

# UpperArm
upperArm = new p2.Body({
  mass: 10
  position: [app.width / 2.0 + 300, app.height - 25]
})
upperArm.addShape(new p2.Box({
  width: 200
  height: 30
  collisionGroup: SKELETON
  collisionMask: GROUND | OTHER
}))
world.addBody(upperArm);
lowerUpperArmJoint= new p2.RevoluteConstraint(lowerArm, upperArm, {
  localPivotA: [100, 0]
  localPivotB: [-100, 0]
})
world.addConstraint(lowerUpperArmJoint);
###