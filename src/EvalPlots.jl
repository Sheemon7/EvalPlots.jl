module EvalPlots

using Reexport
import StatsBase: RealVector, IntegerVector

@reexport using Plots
@reexport using EvalMetrics

# includes
include("mlcurve.jl")
include("curves.jl")

end
