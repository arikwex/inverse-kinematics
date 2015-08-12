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
          .setAngle(-60)
          .setController(@createController(1250, 580, -10, 3500))
          .build())
        .addSegment(new SegmentBuilder(@world)
          .startPadding(30)
          .endPadding(0)
          .bodySize(100, 10)
          .setAngle(90)
          .setController(@createController(870, 330, -10, 2500))
          .build())
      mountX: 75
      mountY: 20
    })
    @limb.segments[0].setDesiredAngle(-0.7)
    @limb.segments[1].setDesiredAngle(1.57)

    # Create Arm with two segments
    @limb2 = @addLimb({
      limb: new Limb(@world)
        .addSegment(new SegmentBuilder(@world)
          .startPadding(30)
          .endPadding(20)
          .bodySize(100, 20)
          .setAngle(-150)
          .setController(@createController(1250, 580, -10, 3500))
          .build())
        .addSegment(new SegmentBuilder(@world)
          .startPadding(30)
          .endPadding(0)
          .bodySize(100, 10)
          .setAngle(90)
          .setController(@createController(870, 330, -10, 2500))
          .build())
      mountX: -75
      mountY: 20
    })
    @limb2.segments[0].setDesiredAngle(-3.1459 + 0.7)
    @limb2.segments[1].setDesiredAngle(1.57)

    setInterval(() =>
      #return
      @limb.segments[0].setDesiredAngle(-0.2)
      @limb2.segments[0].setDesiredAngle(-3.14159 + 0.2)
      #@limb.segments[1].setDesiredAngle(-1.57 + (Math.random() - 0.5) * 2.0)
    , 4000)
    return

  createController: () ->
    return new PIDController({
      Kp: arguments[0]
      Ki: arguments[1]
      Kd: arguments[2]
      maxGain: arguments[3]
      maxAccumulated: 2
    })