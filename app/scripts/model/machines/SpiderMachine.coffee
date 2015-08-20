Skeleton = require('../Skeleton')
Limb = require('../Limb')
SegmentBuilder = require('../SegmentBuilder')
COLLISION = require('enum/collision')
PIDController = require('controller/PIDController')

module.exports = class ArmMachine extends Skeleton
  constructor: (options) ->
    options.width = 40
    options.height = 40
    super(options)

    @config = options.config
    @begin = 0

    @setTexture({
      width: 120
      height: 120
      src: 'images/torso.png'
    })

    @generateLimb({
      femurAngle: @config.femurAngle
      tibiaAngle: @config.tibiaAngle
      tarsusAngle: @config.tarsusAngle
      mountX: options.width / 3.0
      mountY: 30
      group: COLLISION.MUSCLE_FRONT
    })

    @generateLimb({
      femurAngle: @config.femurAngle
      tibiaAngle: @config.tibiaAngle
      tarsusAngle: @config.tarsusAngle
      mountX: options.width / 3.0
      mountY: 30
      group: COLLISION.MUSCLE_BACK
    })

    @generateLimb({
      femurAngle: @config.femurAngle
      tibiaAngle: @config.tibiaAngle
      tarsusAngle: @config.tarsusAngle
      mountX: options.width / 3.0
      mountY: 35
      group: COLLISION.MUSCLE_FRONT2
    })

    @generateLimb({
      femurAngle: @config.femurAngle
      tibiaAngle: @config.tibiaAngle
      tarsusAngle: @config.tarsusAngle
      mountX: options.width / 3.0
      mountY: 35
      group: COLLISION.MUSCLE_BACK2
    })

    @generateLimb({
      femurAngle: 180 - @config.femurAngle
      tibiaAngle: -@config.tibiaAngle
      tarsusAngle: -@config.tarsusAngle
      mountX: -options.width / 3.0
      mountY: 30
      group: COLLISION.MUSCLE_FRONT
    })

    @generateLimb({
      femurAngle: 180 - @config.femurAngle
      tibiaAngle: -@config.tibiaAngle
      tarsusAngle: -@config.tarsusAngle
      mountX: -options.width / 3.0
      mountY: 30
      group: COLLISION.MUSCLE_BACK
    })

    @generateLimb({
      femurAngle: 180 - @config.femurAngle
      tibiaAngle: -@config.tibiaAngle
      tarsusAngle: -@config.tarsusAngle
      mountX: -options.width / 3.0
      mountY: 35
      group: COLLISION.MUSCLE_FRONT2
    })

    @generateLimb({
      femurAngle: 180 - @config.femurAngle
      tibiaAngle: -@config.tibiaAngle
      tarsusAngle: -@config.tarsusAngle
      mountX: -options.width / 3.0
      mountY: 35
      group: COLLISION.MUSCLE_BACK2
    })

    @generateHead()
    @generateAbdomen()
    @generateTurret()
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
          .setController(@createPIDController(200, 1, -1, 1500))
          .build())
        .addSegment(new SegmentBuilder(@world)
          .startPadding(10)
          .endPadding(10)
          .bodySize(90, 10)
          .setAngle(tibiaAngle)
          .setController(@createPIDController(350, 1, -1, 1500))
          .build())
        .addSegment(new SegmentBuilder(@world)
          .startPadding(30)
          .endPadding(0)
          .bodySize(110, 10)
          .setAngle(tarsusAngle)
          .setController(@createPIDController(550, 1, -1, 1500))
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

  generateHead: () ->
    newLimb = @addLimb({
      limb: new Limb(@world)
        .addSegment(new SegmentBuilder(@world)
        .startPadding(0)
        .endPadding(0)
        .bodySize(50, 30)
        .setAngle(0)
        .setController(@createPIDController(200, 1, -1, 1500))
        .build())
      mountX: 30
      mountY: 0
    })
    newLimb.segments[0].setTexture({
      width: 80
      height: 80
      src: 'images/head.png'
    })
    newLimb.setCollisionGroup(COLLISION.MUSCLE_MIDDLE)
    newLimb.setCollisionMask(COLLISION.GROUND | COLLISION.MUSCLE | COLLISION.MUSCLE_MIDDLE)
    return newLimb

  generateAbdomen: () ->
    newLimb = @addLimb({
      limb: new Limb(@world)
        .addSegment(new SegmentBuilder(@world)
        .startPadding(30)
        .endPadding(0)
        .bodySize(210, 50)
        .setAngle(-170)
        .setController(@createPIDController(200, 1, -10, 1500))
        .build())
      mountX: -30
      mountY: 0
    })
    newLimb.segments[0].body.mass *= 0.2
    newLimb.segments[0].setTexture({
      width: 220
      height: 150
      offsetX: -10
      src: 'images/abdomen.png'
    })
    newLimb.setCollisionGroup(COLLISION.MUSCLE_MIDDLE)
    newLimb.setCollisionMask(COLLISION.GROUND | COLLISION.MUSCLE | COLLISION.MUSCLE_MIDDLE)
    return newLimb

  generateTurret: () ->
    newLimb = @addLimb({
      limb: new Limb(@world)
        .addSegment(new SegmentBuilder(@world)
        .startPadding(10)
        .endPadding(0)
        .bodySize(70, 15)
        .setAngle(-0)
        .setController(@createPIDController(100, 1, -1, 1500))
        .build())
      mountX: -15
      mountY: -48
    })
    newLimb.segments[0].setTexture({
      width: 120
      height: 50
      offsetX: -40
      offsetY: 0
      src: 'images/turret.png'
    })
    newLimb.setCollisionGroup(COLLISION.MUSCLE_MIDDLE)
    newLimb.setCollisionMask(COLLISION.GROUND | COLLISION.MUSCLE | COLLISION.MUSCLE_MIDDLE)
    return newLimb

  createPIDController: () ->
    return new PIDController({
      Kp: arguments[0] * 35
      Ki: arguments[1] * 5
      Kd: arguments[2] * 40
      maxGain: arguments[3] * 3
      maxAccumulated: 0.5
    })

  update: (dT) ->
    super(dT)
    time = +new Date() / 1000.0 * @config.gateSpeed
    if @begin < 0.6
      time = (+new Date() / 1000.0 + (0.6 - @begin)) * @config.gateSpeed
      @begin += dT

    d2r = Math.PI / 180.0
    femurBalance = @getAngle() * 0
    tibiaBalance = -@getAngle() * 0
    backPhase = 1.7

    limb = @limbs[10]
    aim = Math.atan2(window.MOUSE.y - limb.segments[0].getY(), window.MOUSE.x - limb.segments[0].getX())
    limb.segments[0].setDesiredAngle(aim - @getAngle())

    limb = @limbs[8]
    aim = Math.atan2(window.MOUSE.y - limb.segments[0].getY(), window.MOUSE.x - limb.segments[0].getX())
    limb.segments[0].setDesiredAngle(aim * 0.5 - 0.1 - @getAngle())

    limb = @limbs[9]
    aim = Math.atan2(window.MOUSE.y - limb.segments[0].getY(), window.MOUSE.x - limb.segments[0].getX())
    limb.segments[0].setDesiredAngle(-3.1 - aim * 0.24 + 0.1)

    for i in [0..3]
      phase = Math.PI * 2.0 / 4.0 * i
      limb = @limbs[i]
      limb.segments[0].setDesiredAngle(@config.femurAngle * d2r - femurBalance)
      limb.segments[1].setDesiredAngle(Math.cos(time + phase) * @config.tibiaSpan + @config.tibiaAngle * d2r - tibiaBalance)
      limb.segments[2].setDesiredAngle(Math.cos(time - @config.tarsusPhase + phase) * @config.tarsusSpan + @config.tarsusAngle * d2r)

    for i in [4..7]
      phase = Math.PI * 2.0 / 4.0 * i
      limb = @limbs[i]
      limb.segments[0].setDesiredAngle((180 - @config.femurAngle) * d2r - femurBalance)
      limb.segments[1].setDesiredAngle(Math.cos(-time + phase + backPhase) * @config.tibiaSpan - @config.tibiaAngle * d2r - tibiaBalance)
      limb.segments[2].setDesiredAngle(Math.cos(-time - @config.tarsusPhase + phase + backPhase) * @config.tarsusSpan - @config.tarsusAngle * d2r)
    return