# ROC curve
@userplot ROCCurve

@recipe function f(h::ROCCurve)
    if length(h.args) != 1 || !(typeof(h.args[1]) <: AbstractVector{<:Counts})
        error("...")
    end
    fx   = EvalMetrics.false_positive_rate
    fy   = EvalMetrics.true_positive_rate
    x, y = EvalMetrics.curve(fx, fy, h.args[1])

    xlabel --> "false positive rate"
    ylabel --> "true positive rate"
    title  --> "ROC curve"

    @series begin
        seriestype := :curve
        diag       := true
        x, y
    end
end

Plots.@deps ROCCurve


# Precision-Recall curve
@userplot PRCurve

@recipe function f(h::PRCurve)
    if length(h.args) != 1 || !(typeof(h.args[1]) <: AbstractVector{<:Counts})
        error("...")
    end
    fx   = EvalMetrics.recall
    fy   = EvalMetrics.precision
    x, y = EvalMetrics.curve(fx, fy, h.args[1])

    xlabel --> "recall"
    ylabel --> "precision"
    title  --> "Precision-Recall curve"

    @series begin
        seriestype := :curve
        x, y
    end
end

Plots.@deps PRCurve


# Precision-quantile curve
@userplot PQuantCurve

@recipe function f(h::PQuantCurve; rev = true)
    if length(h.args) != 1 || !(typeof(h.args[1]) <: AbstractVector{<:Counts})
        error("...")
    end
    fx   = EvalMetrics.quant
    fy   = EvalMetrics.precision
    x, y = EvalMetrics.curve(fx, fy, h.args[1])

    xlab = rev ? "(1-tau) - quantile" : "tau - quantile"
    xlabel --> xlab
    ylabel --> "precision"
    title  --> "Precision-Qunatile curve"

    @series begin
        seriestype := :curve
        xrev       := rev
        x, y
    end
end

Plots.@deps PQuantCurve


# Recall-quantile curve
@userplot RQuantCurve

@recipe function f(h::RQuantCurve; rev = true)
    if length(h.args) != 1 || !(typeof(h.args[1]) <: AbstractVector{<:Counts})
        error("...")
    end
    fx   = EvalMetrics.quant
    fy   = EvalMetrics.recall
    x, y = EvalMetrics.curve(fx, fy, h.args[1])

    xlab = rev ? "(1-tau) - quantile" : "tau - quantile"
    xlabel --> xlab
    ylabel --> "recall"
    title  --> "Recall-Qunatile curve"

    @series begin
        seriestype := :curve
        xrev       := rev
        x, y
    end
end

Plots.@deps RQuantCurve