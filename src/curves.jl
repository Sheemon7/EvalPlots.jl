@recipe function f(cs::CountsVector, fx::Function, fy::Function)
    fx_name = replace(string(fx), "_" => " ")
    fy_name = replace(string(fy), "_" => " ")

    seriestype  :=  :mlcurve
    xlabel      --> fx_name
    ylabel      --> fy_name
    title       --> "$fy_name-$fx_name curve"

    EvalMetrics.curve(fx, fy, cs)
end


# ROC curve
@userplot ROCCurve

@recipe function f(h::ROCCurve)
    if typeof(h.args[1]) <: CountsVector
        args = (h.args[1], false_positive_rate, true_positive_rate)
    else
        args = h.args
    end
    @series begin
        seriestype := :mlcurve
        diag   --> true
        title  --> "ROC curve"
        args
    end
end

Plots.@deps ROCCurve


# Precision-Recall curve
@userplot PRCurve

@recipe function f(h::PRCurve)
    if typeof(h.args[1]) <: CountsVector
        args = (h.args[1], recall, precision)
    else
        args = h.args
    end
    @series begin
        seriestype := :mlcurve
        title  --> "Precision-Recall curve"
        args
    end
end

Plots.@deps PRCurve


# Precision-quantile curve
@userplot PQuantCurve

@recipe function f(h::PQuantCurve; rev = true)
    if typeof(h.args[1]) <: CountsVector
        args = (h.args[1], quant, precision)
    else
        args = h.args
    end
    @series begin
        seriestype := :mlcurve
        title  --> "Precision-Quantile curve"
        ylabel --> "quantile"
        args
    end
end

Plots.@deps PQuantCurve


# Recall-quantile curve
@userplot RQuantCurve

@recipe function f(h::RQuantCurve; rev = true)
    if typeof(h.args[1]) <: CountsVector
        args = (h.args[1], recall, precision)
    else
        args = h.args
    end
    @series begin
        seriestype := :mlcurve
        title  --> "Recall-Quantile curve"
        ylabel --> "quantile"
        args
    end
end

Plots.@deps RQuantCurve