Skeleton = require('../Skeleton')
Limb = require('../Limb')
SegmentBuilder = require('../SegmentBuilder')
COLLISION = require('enum/collision')
PIDController = require('controller/PIDController')

module.exports = class ArmMachine extends Skeleton
  constructor: (options) ->
    super(options)

    @setTexture({
      width: 380
      height: 120
      src: 'images/torso.png'
    })

    @generateLimb({
      femurAngle: 25
      tibiaAngle: -110
      tarsusAngle: 60
      mountX: options.width / 8.0
      mountY: 40
      group: COLLISION.MUSCLE_FRONT
    })

    @generateLimb({
      femurAngle: 155
      tibiaAngle: 110
      tarsusAngle: -60
      mountX: -options.width / 8.0
      mountY: 40
      group: COLLISION.MUSCLE_FRONT
    })

    @generateLimb({
      femurAngle: 25
      tibiaAngle: -110
      tarsusAngle: 60
      mountX: options.width / 8.0
      mountY: 40
      group: COLLISION.MUSCLE_BACK
    })

    @generateLimb({
      femurAngle: 155
      tibiaAngle: 110
      tarsusAngle: -60
      mountX: -options.width / 8.0
      mountY: 40
      group: COLLISION.MUSCLE_BACK
    })
    return

  generateLimb: (options) ->
    { femurAngle
      tibiaAngle
      tarsusAngle
      mountX
      mountY
      group } = options

    newLimb = @addLimb({
      limb: new Limb(@world)
        .addSegment(new SegmentBuilder(@world)
          .startPadding(10)
          .endPadding(10)
          .bodySize(50, 10)
          .setAngle(femurAngle)
          .setController(@createPIDController(250, 1, -1, 1500))
          .build())
        .addSegment(new SegmentBuilder(@world)
          .startPadding(10)
          .endPadding(10)
          .bodySize(110, 10)
          .setAngle(tibiaAngle)
          .setController(@createPIDController(550, 1, -3, 1500))
          .build())
        .addSegment(new SegmentBuilder(@world)
          .startPadding(30)
          .endPadding(0)
          .bodySize(110, 10)
          .setAngle(tarsusAngle)
          .setController(@createPIDController(1550, 1, -2, 1500))
          .build())
      mountX: mountX
      mountY: mountY
    })

    flip = 1
    if Math.cos(femurAngle) < 0
      flip = -1
    newLimb.segments[0].setTexture({
      width: 60
      height: 35 * flip
      src: 'images/leg_top.png'
    })
    newLimb.segments[1].setTexture({
      width: 120
      height: 35 * flip
      src: 'images/leg_middle.png'
    })
    newLimb.segments[2].setTexture({
      width: 130
      height: 35 * flip
      src: 'images/leg_bottom.png'
    })

    newLimb.setCollisionGroup(group)
    newLimb.setCollisionMask(COLLISION.GROUND | COLLISION.MUSCLE | group)
    return newLimb

  createPIDController: () ->
    return new PIDController({
      Kp: arguments[0] * 205
      Ki: arguments[1] * 115
      Kd: arguments[2] * 110
      maxGain: arguments[3] * 3
      maxAccumulated: 0.5
    })

  update: (dT) ->
    super(dT)
    time = +new Date() / 1000.0 * 1.5
    limb = @limbs[0]
    limb.segments[1].setDesiredAngle(Math.cos(time + 3) * 0.35 - 60 / 57.3)
    limb.segments[2].setDesiredAngle(Math.cos(time - 2.4 + 3) * 0.4 + 1.97)

    limb = @limbs[2]
    limb.segments[1].setDesiredAngle(Math.cos(time) * 0.35 - 60 / 57.3)
    limb.segments[2].setDesiredAngle(Math.cos(time - 2.4) * 0.4 + 1.97)

    limb = @limbs[1]
    limb.segments[1].setDesiredAngle(Math.cos(-time + 1.57) * 0.35 + 60 / 57.3)
    limb.segments[2].setDesiredAngle(Math.cos(-time - 2.4 + 1.57) * 0.4 - 1.97)

    limb = @limbs[3]
    limb.segments[1].setDesiredAngle(Math.cos(-time + 1.57 - 3) * 0.35  + 60 / 57.3)
    limb.segments[2].setDesiredAngle(Math.cos(-time - 2.4 + 1.57 - 3) * 0.4 - 1.97)