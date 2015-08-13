p2 = require('p2')
COLLISION = require('enum/collision')
Renderer = require('renderer')

module.exports = class Environment
  constructor: () ->
    @initWorld()
    @initGround()
    @entities = []
    return

  initWorld: () ->
    # Create the world
    @world = new p2.World({
      gravity: [0, 980]
    })

    # Pre-fill object pools. Completely optional but good for performance!
    @world.overlapKeeper.recordPool.resize(16)
    @world.islandManager.islandPool.resize(128)
    @world.islandManager.nodePool.resize(1024)
    @world.narrowphase.contactEquationPool.resize(1024)
    @world.narrowphase.frictionEquationPool.resize(1024)

    # Set default object behaviors
    @world.setGlobalStiffness(1e8)           # Set stiffness of all contacts and constraints
    @world.sleepMode = p2.World.NO_SLEEPING  # Enables sleeping of bodies

    # Configure solver
    @world.solver.iterations = 20            # Max number of solver iterations to do
    @world.solver.tolerance = 0.02           # Solver error tolerance

    #
    window.GROUND = new p2.Material()
    window.MUSCLE = new p2.Material()
    window.TEST = new p2.ContactMaterial(window.GROUND, window.MUSCLE, {
      friction : 100.0
    })
    @world.addContactMaterial(window.TEST)
    return

  initGround: () ->
    # Create ground plane
    plane = new p2.Body({
      position : [0, 600],
      angle: Math.PI,
    })
    plane.addShape(new p2.Plane({
      collisionGroup: COLLISION.GROUND
      collisionMask: COLLISION.MUSCLE
    }));
    plane.shapes[0].material = window.GROUND
    @world.addBody(plane);
    return

  getWorld: () ->
    return @world

  addEntity: (entity) ->
    @entities.push(entity)
    return

  update: (dT) ->
    @world.step(dT)
    for entity in @entities
      entity.update(dT)
    return

  render: (gfx) ->
    gfx.strokeStyle = '#259'
    gfx.lineWidth = 1
    gfx.beginPath()
    gfx.moveTo(0, 600)
    gfx.lineTo(2000, 600)
    gfx.stroke()
    for entity in @entities
      Renderer.render(gfx, entity)
    return