# -------------------------------------------------------------------------------
# Scores density
# -------------------------------------------------------------------------------
getntuplefield(tpl::NamedTuple, key::Symbol, default) = 
    haskey(tpl, key) ? getfield(tpl, key) : default

@userplot ScoresDensity

@recipe function f(h::ScoresDensity; thres = [])
    if length(h.args) != 2
        error("...")
    end

    target, scores = h.args

    classes = sort(unique(target))
    lbls    = ["class $class" for class in sort(unique(target))]
    
    grid   --> false
    yaxis  --> false
    legend --> :topleft
    title  --> "Scores"

    @series begin
        seriestype := :density
        marker     := :none
        trim       --> true
        label      --> reshape(lbls, 1, length(lbls))
        fill       --> (true, 0, 0.5)
        [scores[target .== class] for class in classes]
    end

    for tpl in thres
        @series begin
            seriestype := :vline
            marker     := :none
            label      := getntuplefield(tpl, :label, "")
            line       := getntuplefield(tpl, :style, (:dash))
            fill       := false
            [tpl.value]
        end
    end
end

Plots.@deps ScoresDensity




# -------------------------------------------------------------------------------
# Metric curves
# -------------------------------------------------------------------------------
struct MLCurve
    fx::Function
    fy::Function
end


@recipe f(h::MLCurve, c::CountsArray) =
    (h.fx(c), h.fy(c))

@recipe f(h::MLCurve, cs::AbstractArray{<:CountsVector}) =
    [(h.fx(c), h.fy(c)) for c in cs]

@recipe f(h::MLCurve, x::AbstractArray, y::AbstractArray) =
    (x, y)


function outputs(fx::Function, fy::Function, args::Tuple)
    if typeof(args[1]) <: AbstractArray{<:Real}
        return args
    else 
        return (MLCurve(fx, fy), args...) 
    end
end


# ROC curve
@userplot ROCCurve

@recipe function f(h::ROCCurve)
    seriestype := :mlcurve
    diagonal   --> true
    legend     := :bottomright
    fillrange  --> 0
    fillalpha  --> 0.15
    title      --> "ROC curve"
    xlabel     --> "false positive rate"
    ylabel     --> "true positive rate"

    outputs(false_positive_rate, true_positive_rate, h.args)
end

Plots.@deps ROCCurve


# Precision-Recall curve
@userplot PRCurve

@recipe function f(h::PRCurve)
    seriestype := :mlcurve
    legend     := :bottomleft
    fillrange  --> 0
    fillalpha  --> 0.15
    title      --> "Precision-Recall curve"
    xlabel     --> "recall"
    ylabel     --> "precision"

    outputs(recall, precision, h.args) 
end

Plots.@deps PRCurve


# Precision-quantile curve
@userplot PQuantCurve

@recipe function f(h::PQuantCurve; top = false)
    seriestype := :mlcurve
    legend     := :bottomleft
    fillrange  --> 0
    fillalpha  --> 0.15
    title      --> "Precision-Quantile curve"
    xlabel     --> "quantile"
    ylabel     --> "precision"

    outputs(quant, precision, h.args)
end

Plots.@deps PQuantCurve


# Precision-topquantile curve
@userplot PTopQuantCurve

@recipe function f(h::PTopQuantCurve; top = false)
    seriestype := :mlcurve
    legend     := :bottomleft
    fillrange  --> 0
    fillalpha  --> 0.15
    title      --> "Precision-Quantile curve"
    xlabel     --> "top-quantile"
    ylabel     --> "precision"

    outputs(topquant, precision, h.args)
end

Plots.@deps PTopQuantCurve


# Recall-quantile curve
@userplot RQuantCurve

@recipe function f(h::RQuantCurve; top = false)
    seriestype := :mlcurve
    legend     := :bottomleft
    fillrange  --> 0
    fillalpha  --> 0.15
    title      --> "Recall-Quantile curve"
    xlabel     --> "top-quantile"
    ylabel     --> "recall"

    outputs(quant, precision, h.args)
end

Plots.@deps RQuantCurve


# Recall-quantile curve
@userplot RTopQuantCurve

@recipe function f(h::RTopQuantCurve; top = false)
    seriestype := :mlcurve
    legend     := :bottomleft
    fillrange  --> 0
    fillalpha  --> 0.15
    title      --> "Recall-Quantile curve"
    xlabel     --> "top-quantile"
    ylabel     --> "recall"

    outputs(topquant, precision, h.args)
end

Plots.@deps RTopQuantCurve


# TPR-quantile curve
@userplot TPRQuantCurve

@recipe function f(h::TPRQuantCurve; top = false)
    seriestype := :mlcurve
    legend     := :bottomleft
    fillrange  --> 0
    fillalpha  --> 0.15
    title      --> "TPR-Quantile curve"
    xlabel     --> "quantile"
    ylabel     --> "TPR"

    outputs(topquant, true_positive_rate, h.args)
end

Plots.@deps TPRQuantCurve


# TPR-quantile curve
@userplot TPRTopQuantCurve

@recipe function f(h::TPRTopQuantCurve; top = false)
    seriestype := :mlcurve
    legend     := :bottomleft
    fillrange  --> 0
    fillalpha  --> 0.15
    title      --> "TPR-Quantile curve"
    xlabel     --> "top-quantile"
    ylabel     --> "TPR"

    outputs(topquant, true_positive_rate, h.args)
end

Plots.@deps TPRTopQuantCurve