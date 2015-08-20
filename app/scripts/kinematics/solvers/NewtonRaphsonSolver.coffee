numeric = require('numeric')

module.exports = {
  solve: (model, startState, goalPose, iterations) ->
    # Goal is to compute dS = J^-1 * dP
    # Where:
    #   S is the state space
    #   P is the position space
    #   J is the Jacobian at X_k

    S = startState.slice()

    for iter in [1..iterations]
      P = model.computePose(S)
      J = model.computeJacobian(S)
      dP = model.computeDifference(goalPose, P)
      Jinv = @pinv(J)
      dS = numeric.dot(Jinv, dP)
      for i in [0..S.length-1]
        S[i] += dS[i]

    return S

  pinv: (A) ->
    z = numeric.svd(A)
    foo = z.S[0]
    U = z.U
    S = z.S
    V = z.V
    m = A.length
    n = A[0].length
    tol = Math.max(m,n) * numeric.epsilon * foo
    M = S.length
    Sinv = new Array(M)
    i = M - 1
    while (i != -1)
      if (S[i] > tol)
        Sinv[i] = 1 / S[i]
      else
        Sinv[i] = 0
      i--
    return numeric.dot(numeric.dot(U, numeric.diag(Sinv)), numeric.transpose(V))
}