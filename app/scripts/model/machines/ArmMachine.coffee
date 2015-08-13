Skeleton = require('../Skeleton')
Limb = require('../Limb')
SegmentBuilder = require('../SegmentBuilder')

PIDController = require('controller/PIDController')

module.exports = class ArmMachine extends Skeleton
  constructor: (options) ->
    super(options)
    # Create Arm with two segments
    @limb = @addLimb({
      limb: new Limb(@world)
        .addSegment(new SegmentBuilder(@world)
          .startPadding(30)
          .endPadding(20)
          .bodySize(100, 20)
          .setAngle(0)
          .setController(@createPIDController(1250, 580, -10, 3500))
          .build())
        .addSegment(new SegmentBuilder(@world)
          .startPadding(30)
          .endPadding(0)
          .bodySize(100, 10)
          .setAngle(90)
          .setController(@createPIDController(870, 330, -4, 2500))
          .build())
      mountX: 75
      mountY: 20
    })
    @limb.segments[0].setDesiredAngle(-0.4)
    @limb.segments[1].setDesiredAngle(1.8)

    # Create Arm with two segments
    @limb2 = @addLimb({
      limb: new Limb(@world)
        .addSegment(new SegmentBuilder(@world)
          .startPadding(30)
          .endPadding(20)
          .bodySize(100, 20)
          .setAngle(-180)
          .setController(@createPIDController(1250, 580, -10, 3500))
          .build())
        .addSegment(new SegmentBuilder(@world)
          .startPadding(30)
          .endPadding(0)
          .bodySize(100, 10)
          .setAngle(-90)
          .setController(@createPIDController(870, 330, -4, 2500))
          .build())
      mountX: -75
      mountY: 20
    })
    @limb2.segments[0].setDesiredAngle(-3.14159 + 0.4)
    @limb2.segments[1].setDesiredAngle(-1.8)

    setInterval(() =>
      @limb.segments[0].setDesiredAngle(0.8)
      @limb2.segments[0].setDesiredAngle(-3.14159 - 0.8)
      @limb.segments[1].setDesiredAngle(0.8)
      @limb2.segments[1].setDesiredAngle(-0.8)
      setTimeout(() =>
        @limb.segments[0].setDesiredAngle(-0.4)
        @limb2.segments[0].setDesiredAngle(-3.14159 + 0.4)
        @limb.segments[1].setDesiredAngle(1.8)
        @limb2.segments[1].setDesiredAngle(-1.8)
      , 1400)
    , 6000)
    return

  createPIDController: () ->
    return new PIDController({
      Kp: arguments[0] * 4
      Ki: arguments[1] * 1
      Kd: arguments[2] * 0
      maxGain: arguments[3]
      maxAccumulated: 0.5
    })