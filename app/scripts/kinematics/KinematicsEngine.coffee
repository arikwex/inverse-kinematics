solverMap = {
  'Newton-Raphson': require('./solvers/NewtonRaphsonSolver')
}

class KinematicsEngine
  constructor: () ->
    return

  solve: (options) ->
    { @model
      @startState
      @goalPose
      @iterations
      @method } = options

    @method = @method || 'Newton-Raphson'
    @iterations = @iterations || 10

    SolverMethod = solverMap[@method]
    if SolverMethod
      return SolverMethod.solve(
        @model
        @startState
        @goalPose
        @iterations)

    return []

module.exports = new KinematicsEngine()