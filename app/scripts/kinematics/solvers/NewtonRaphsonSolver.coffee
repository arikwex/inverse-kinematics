module.exports = {
  solve: (model, startState, goalPose, iterations) ->
    # Goal is to compute dS = J^-1 * dP
    # Where:
    #   S is the state space
    #   P is the position space
    #   J is the Jacobian at X_k

    # currentPose = model.computePose(startState)
    # jacobian = model.computeJacobian(startState)
    # X = startState

    # dP = model.computeDifference(goalPose, currentPose)
    # gamma = 0.002
    # for i in [0..dP.length-1]
    #   for j in [0..X.length-1]
    #     dX = 1.0 / jacobian[i][j] * dP[i] * gamma
    #     X[j] += dX
    return startState
}