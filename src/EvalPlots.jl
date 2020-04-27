module EvalPlots

using Reexport
import StatsBase: RealVector, IntegerVector

@reexport using StatsPlots
@reexport using EvalMetrics

# includes
include("seriesrecipes.jl")
include("curves.jl")

end
