Skeleton = require('../Skeleton')
Limb = require('../Limb')
SegmentBuilder = require('../SegmentBuilder')
COLLISION = require('enum/collision')
PIDController = require('controller/PIDController')

module.exports = class ArmMachine extends Skeleton
  constructor: (options) ->
    super(options)

    @generateLimb({
      hipAngle: -20
      kneeAngle: 90
      mountX: 75
      mountY: 20
      group: COLLISION.MUSCLE_FRONT
    })

    @generateLimb({
      hipAngle: -160
      kneeAngle: -90
      mountX: -75
      mountY: 20
      group: COLLISION.MUSCLE_FRONT
    })

    @generateLimb({
      hipAngle: -50
      kneeAngle: 90
      mountX: 75
      mountY: 20
      group: COLLISION.MUSCLE_BACK
    })

    @generateLimb({
      hipAngle: -130
      kneeAngle: -90
      mountX: -75
      mountY: 20
      group: COLLISION.MUSCLE_BACK
    })

    #return
    setInterval(() =>
      @limbs[0].segments[0].setDesiredAngle(0.8)
      @limbs[1].segments[0].setDesiredAngle(-3.14159 - 0.8)
      @limbs[0].segments[1].setDesiredAngle(0.8)
      @limbs[1].segments[1].setDesiredAngle(-0.8)
    , 4000)
    return

  generateLimb: (options) ->
    { hipAngle
      kneeAngle
      mountX
      mountY
      group } = options

    newLimb = @addLimb({
      limb: new Limb(@world)
        .addSegment(new SegmentBuilder(@world)
          .startPadding(30)
          .endPadding(20)
          .bodySize(100, 20)
          .setAngle(hipAngle)
          .setController(@createPIDController(1250, 780, -20, 3500))
          .build())
        .addSegment(new SegmentBuilder(@world)
          .startPadding(30)
          .endPadding(0)
          .bodySize(100, 10)
          .setAngle(kneeAngle)
          .setController(@createPIDController(377, 130, -1, 2500))
          .build())
      mountX: mountX
      mountY: mountY
    })

    newLimb.setCollisionGroup(group)
    newLimb.setCollisionMask(COLLISION.GROUND | COLLISION.MUSCLE | group)
    return newLimb


  createPIDController: () ->
    return new PIDController({
      Kp: arguments[0] * 105
      Ki: arguments[1] * 15
      Kd: arguments[2] * 50
      maxGain: arguments[3]
      maxAccumulated: 0.5
    })