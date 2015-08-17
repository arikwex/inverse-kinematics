Skeleton = require('../Skeleton')
Limb = require('../Limb')
SegmentBuilder = require('../SegmentBuilder')
COLLISION = require('enum/collision')
PIDController = require('controller/PIDController')

module.exports = class ArmMachine extends Skeleton
  constructor: (options) ->
    super(options)

    @config = options.config
    @begin = 0

    @setTexture({
      width: 380
      height: 120
      src: 'images/torso.png'
    })

    @generateLimb({
      femurAngle: @config.femurAngle
      tibiaAngle: @config.tibiaAngle
      tarsusAngle: @config.tarsusAngle
      mountX: options.width / 8.0
      mountY: 40
      group: COLLISION.MUSCLE_FRONT
    })

    @generateLimb({
      femurAngle: 180 - @config.femurAngle
      tibiaAngle: -@config.tibiaAngle
      tarsusAngle: -@config.tarsusAngle
      mountX: -options.width / 8.0
      mountY: 40
      group: COLLISION.MUSCLE_FRONT
    })

    @generateLimb({
      femurAngle: @config.femurAngle
      tibiaAngle: @config.tibiaAngle
      tarsusAngle: @config.tarsusAngle
      mountX: options.width / 8.0
      mountY: 40
      group: COLLISION.MUSCLE_BACK
    })

    @generateLimb({
      femurAngle: 180 - @config.femurAngle
      tibiaAngle: -@config.tibiaAngle
      tarsusAngle: -@config.tarsusAngle
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
          .setController(@createPIDController(200, 0, -1, 1500))
          .build())
        .addSegment(new SegmentBuilder(@world)
          .startPadding(10)
          .endPadding(10)
          .bodySize(90, 10)
          .setAngle(tibiaAngle)
          .setController(@createPIDController(350, 0, -1, 1500))
          .build())
        .addSegment(new SegmentBuilder(@world)
          .startPadding(30)
          .endPadding(0)
          .bodySize(110, 10)
          .setAngle(tarsusAngle)
          .setController(@createPIDController(550, 0, -1, 1500))
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
      width: 100
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
      Kp: arguments[0] * 25
      Ki: arguments[1] * 15
      Kd: arguments[2] * 110
      maxGain: arguments[3] * 3
      maxAccumulated: 0.5
    })

  update: (dT) ->
    super(dT)
    time = +new Date() / 1000.0 * 0.0#@config.gateSpeed
    if @begin < 0.6
      time = (+new Date() / 1000.0 + (0.6 - @begin)) * @config.gateSpeed
      @begin += dT

    d2r = Math.PI / 180.0
    femurBalance = @getAngle()
    tibiaBalance = -@getAngle()

    limb = @limbs[0]
    limb.reachPose({
      x: window.MOUSE.x
      y: window.MOUSE.y
    })
    #limb.segments[0].setDesiredAngle(@config.femurAngle * d2r - femurBalance)
    #limb.segments[1].setDesiredAngle(Math.cos(time + 3) * @config.tibiaSpan + @config.tibiaAngle * d2r - tibiaBalance)
    #limb.segments[2].setDesiredAngle(Math.cos(time - @config.tarsusPhase + 3) * @config.tarsusSpan + @config.tarsusAngle * d2r)

    limb = @limbs[2]
    limb.powerDown()
    # limb.segments[0].setDesiredAngle(@config.femurAngle * d2r - femurBalance)
    # limb.segments[1].setDesiredAngle(Math.cos(time) * @config.tibiaSpan + @config.tibiaAngle * d2r - tibiaBalance)
    # limb.segments[2].setDesiredAngle(Math.cos(time - @config.tarsusPhase) * @config.tarsusSpan + @config.tarsusAngle * d2r)

    limb = @limbs[1]
    limb.powerDown()
    # limb.segments[0].setDesiredAngle((180 - @config.femurAngle) * d2r - femurBalance)
    # limb.segments[1].setDesiredAngle(Math.cos(-time + 1.57) * @config.tibiaSpan - @config.tibiaAngle * d2r - tibiaBalance)
    # limb.segments[2].setDesiredAngle(Math.cos(-time - @config.tarsusPhase + 1.57) * @config.tarsusSpan - @config.tarsusAngle * d2r)

    limb = @limbs[3]
    limb.powerDown()
    # limb.segments[0].setDesiredAngle((180 - @config.femurAngle) * d2r - femurBalance)
    # limb.segments[1].setDesiredAngle(Math.cos(-time + 1.57 - 3) * @config.tibiaSpan - @config.tibiaAngle * d2r - tibiaBalance)
    # limb.segments[2].setDesiredAngle(Math.cos(-time - @config.tarsusPhase + 1.57 - 3) * @config.tarsusSpan - @config.tarsusAngle * d2r)
    return