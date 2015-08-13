module.exports = class RampController
  constructor: (options) ->
    { @Kp, @Ki, @Kd
      @maxAccumulated
      @maxGain } = options

    # Controller Max Gain
    @_maxGain =  @_maxGain || 1
    @_ramp = 1

    # Integration variables
    @_accumulated = 0
    @maxAccumulated = @maxAccumulated || 1

    # Derivative variables
    @_lastDifference = null
    return

  step: (desired, observed, dT) ->
    # Compute different
    difference = desired - observed

    # Compute derivate term
    derivative = 0
    if @_lastDifference
      derivative = (observed - @_lastDifference) / dT
    @_lastDifference = observed

    # Manage integral term
    @_accumulated += difference * @_ramp * dT
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

    # Ramp behavior
    # @_accumulated *= 1.0 / (0.5 + Math.abs(derivative) * 0.2)
    # @_ramp *= 1.0 / (0.5 + Math.abs(derivative) * 8.0)
    # if @_ramp < 1
    #   @_ramp = 1

    # Return thresholded gain
    return gain