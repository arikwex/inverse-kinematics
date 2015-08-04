$ = require('jquery')
p2 = require('p2')
window.p2 = p2;
p2Renderer = require('p2/build/p2.renderer')
animation = require('animation')
Frame = require('./view/Frame')

app = new Frame()
$('app-body').append(app.$el)

window.app = app
window.animation = animation
window.$ = $

window.Q = -10000
window.W = -10000

# Create the world
world = new p2.World({
  gravity : [0, 980]
});

# Pre-fill object pools. Completely optional but good for performance!
world.overlapKeeper.recordPool.resize(16)
world.islandManager.islandPool.resize(128)
world.islandManager.nodePool.resize(1024)
world.narrowphase.contactEquationPool.resize(1024)
world.narrowphase.frictionEquationPool.resize(1024)

# Set stiffness of all contacts and constraints
world.setGlobalStiffness(1e8)
# Max number of solver iterations to do
world.solver.iterations = 20
# Solver error tolerance
world.solver.tolerance = 0.02
# Enables sleeping of bodies
world.sleepMode = p2.World.NO_SLEEPING

# Compute max/min positions of circles
xmin = (0)
xmax = (app.width)
ymin = (0)
ymax = (app.height)

GROUND = 1
SKELETON = 4
OTHER = 8

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

# Create bottom plane
plane = new p2.Body({
  position : [0, ymax],
  angle: Math.PI,
})
plane.addShape(new p2.Plane({
  collisionGroup: GROUND
  collisionMask: SKELETON
}));
world.addBody(plane);

# Start demo
app.setWorld(world)
window.world = world;
window.lowerArm = lowerArm
window.upperArm = upperArm