p2 = require('p2')
AbstractEntity = require('./AbstractEntity')
COLLISION = require('enum/collision')
KinematicsEngine = require('kinematics/KinematicsEngine')
KinematicsModel = require('kinematics/KinematicsModel')

module.exports = class Limb extends AbstractEntity
  constructor: (@world) ->
    @_visualization = 'limb'
    @segments = []
    return

  setCollisionGroup: (group) ->
    @collisionGroup = group
    for segment in @segments
      segment.setCollisionGroup(group)
    return

  setCollisionMask: (mask) ->
    for segment in @segments
      segment.setCollisionMask(mask)
    return

  addSegment: (newSegment) ->
    # Chain segment references
    if (@segments.length > 0)
      previousSegment = @segments[@segments.length - 1]
      newSegment.setPrevious(previousSegment)
      previousSegment.setNext(newSegment)
      joint = new p2.RevoluteConstraint(previousSegment.body, newSegment.body, {
        localPivotA:[previousSegment.width / 2.0, 0]
        localPivotB:[-newSegment.width / 2.0, 0]
      })
      newSegment.setPreviousConstraint(joint)
      previousSegment.setNextConstraint(joint)
      @world.addConstraint(joint)

    # Track the new segment
    newSegment.setLimb(@)
    @segments.push(newSegment)
    return @

  removeSegment: (segmentToRemove) ->
    indexToRemove = 0
    remove = false
    for segment in @segments
      if segment == segmentToRemove
        remove = true
        break
      indexToRemove++
    if remove
      @segments.splice(indexToRemove, 1)
    return

  getFirstSegment: () ->
    if (@segments.length > 0)
      return @segments[0]
    return null

  smartPositioning: () ->
    startAngle = @skeleton.getAngle()
    C = Math.cos(startAngle)
    S = Math.sin(startAngle)
    startX = @skeleton.getX() + C * @mountX - S * @mountY
    startY = @skeleton.getY() + S * @mountX + C * @mountY
    for segment in @segments
      dA = segment.desiredAngle
      startAngle += dA
      dX = Math.cos(startAngle) * segment.width
      dY = Math.sin(startAngle) * segment.width
      segment.body.position[0] = startX + dX * 0.5
      segment.body.position[1] = startY + dY * 0.5
      segment.body.angle = startAngle
      startX += dX
      startY += dY
    return

  reachRelativePose: (relPose) ->
    startAngle = @skeleton.getAngle()
    C = Math.cos(startAngle)
    S = Math.sin(startAngle)
    startX = @skeleton.getX() + C * @mountX - S * @mountY
    startY = @skeleton.getY() + S * @mountX + C * @mountY
    @reachPose([
      startX + relPose[0]
      startY + relPose[1]
    ])
    return

  reachPose: (goalPose) ->
    resultState = KinematicsEngine.solve({
      model: @getModel()
      startState: @getSegmentState()
      goalPose: goalPose
      iterations: 5
    })
    for i in [0..resultState.length-1]
      segment = @segments[i]
      if segment
        segment.setDesiredAngle(resultState[i])
    return

  setSkeleton: (@skeleton) ->
    firstSegment = @.getFirstSegment()
    if firstSegment
      firstSegment.setPrevious(@skeleton)
    return

  getEnv: () ->
    return @skeleton.getEnv()

  setMountingPoint: (@mountX, @mountY) ->
    return

  update: (dT) ->
    for segment in @segments
      segment.update(dT)
    return

  powerDown: () ->
    for segment in @segments
      segment.powerDown()
    return

  disconnect: () ->
    if (@segments.length > 0)
      segment = @segments[0]
      segment.disconnectPrevious()
    @skeleton.removeLimb(@)
    @getEnv().addEntity(@)
    @setCollisionGroup(COLLISION.MUSCLE)
    @setCollisionMask(COLLISION.ALL)
    return

  dispose: () ->
    while @segments.length > 0
      @segments[0].dispose()
    @skeleton.removeLimb(@)
    return

  getSegmentState: () ->
    state = Array(@segments.length)
    for i in [0..state.length-1]
      state[i] = @segments[i].getRelativeAngle()
    return state

  getModel: () ->
    return @model

  generateModel: () ->
    skeleton = @skeleton
    segments = @segments
    mountX = @mountX
    mountY = @mountY
    Model = class LimbModel extends KinematicsModel
      computePose: (state) ->
        pose = [skeleton.getX(), skeleton.getY(), skeleton.getAngle()]
        C = Math.cos(pose[2])
        S = Math.sin(pose[2])
        pose[0] += C * mountX - S * mountY
        pose[1] += S * mountX + C * mountY
        for i in [0..state.length-1]
          segment = segments[i]
          dA = state[i]
          pose[2] += dA
          dX = Math.cos(pose[2]) * segment.width
          dY = Math.sin(pose[2]) * segment.width
          pose[0] += dX
          pose[1] += dY
        return [pose[0], pose[1]]
    @model = new Model()
