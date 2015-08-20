module.exports = class KinematicsModel
  constructor: () ->
    return

  computeDifference: (A, B) ->
    res = Array(A.length)
    for i in [0..A.length-1]
      res[i] = A[i] - B[i]
    return res

  computePose: (state) ->
    return []

  computeJacobian: (state) ->
    # Attempts to compute Jacobian with finite differentials.
    # Can be overriden by an inherited class.
    Nstate = state.length
    currentPose = @computePose(state)
    Npose = currentPose.length

    jacobian = Array(Nstate)
    for i in [0..Nstate-1]
      jacobian[i] = Array(Npose)

    for i in [0..Nstate-1]
      dP_di = @computePoseDerivative(currentPose, state, i)
      for j in [0..Npose-1]
        jacobian[i][j] = dP_di[j]
    return jacobian

  computePoseDerivative: (pose, state, stateVaryIndex) ->
    h = 0.001
    differentialState = Array(state.length)
    for i in [0..state.length-1]
      differentialState[i] = state[i]
    differentialState[stateVaryIndex] += h
    incrementedPose = @computePose(differentialState)
    differentialPose = @computeDifference(incrementedPose, pose)
    for j in [0..differentialPose.length-1]
      differentialPose[j] = differentialPose[j] / h
    return differentialPose