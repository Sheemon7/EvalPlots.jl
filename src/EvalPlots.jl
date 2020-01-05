module EvalPlots

using Reexport
import EvalMetrics
import EvalMetrics: Counts
import StatsBase: RealVector, IntegerVector, IntegerMatrix

@reexport using Plots

# includes
include("curve.jl")
include("basic_curves.jl")

end
