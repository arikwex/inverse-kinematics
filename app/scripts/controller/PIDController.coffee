module.exports = class PIDController
  constructor: (options) ->
    { @Kp, @Ki, @Kd
      @maxAccumulated
      @maxGain } = options

    # Controller Max Gain
    @_maxGain =  @_maxGain || 1

    # Integration variables
    @_accumulated = 0
    @maxAccumulated = @maxAccumulated || 1

    # Derivative variables
    @_lastDifference = null
    return

  step: (desired, observed, dT) ->
    # Compute different
    difference = observed - desired

    # Compute derivate term
    derivative = 0
    if @_lastDifference
      derivative = (@_lastDifference - difference) / dT
    @_lastDifference = difference

    # Manage integral term
    @_accumulated += difference
    if @_accumulated > @maxAccumulated
      @_accumulated = @maxAccumulated
    else if @_accumulated < -@maxAccumulated
      @_accumulated = -@maxAccumulated

    # Compute PID gain
    gain =  difference * @Kp
    gain += @_accumulated * @Ki
    gain += derivative * @Kd

    # Threshold the gain
    if gain > @maxGain
      gain = @maxGain
    else if gain < -@maxGain
      gain = -@maxGain

    # Return thresholded gain
    return gain