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
    difference = desired - observed

    # Compute derivate term
    derivative = 0
    if @_lastDifference
      derivative = (observed - @_lastDifference) / dT
    @_lastDifference = observed
    if (derivative < 0 and difference < 0)
      derivative = 0
    if (derivative > 0 and difference > 0)
      derivative = 0

    # Manage integral term
    @_accumulated += difference * dT
    if @_accumulated > @maxAccumulated
      @_accumulated = @maxAccumulated
    else if @_accumulated < -@maxAccumulated
      @_accumulated = -@maxAccumulated
    #@_accumulated *= 1.0 / (1.0 + Math.abs(derivative) * 0.05)

    # Compute PID gain
    gain =  difference * @Kp
    gain += @_accumulated * @Ki
    gain += derivative * @Kd * (1.0 + Math.abs(@_accumulated) * 7.0)

    # Threshold the gain
    if gain > @maxGain
      gain = @maxGain
    else if gain < -@maxGain
      gain = -@maxGain

    # Return thresholded gain
    return gain