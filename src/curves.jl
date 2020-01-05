@recipe function f(cs::CountsVector, fx::Function, fy::Function)
    fx_name = replace(string(fx), "_" => " ")
    fy_name = replace(string(fy), "_" => " ")

    seriestype  :=  :mlcurve
    xlabel      --> fx_name
    ylabel      --> fy_name
    title       --> "$fy_name-$fx_name curve"

    EvalMetrics.curve(fx, fy, cs)
end


function _get_arguments(mtd, args, fx::Function, fy::Function)
    n = length(args)
    if n == 1 && typeof(args[1]) <: CountsVector 
        return (args[1], fx, fy)
    elseif n == 2 && typeof(args[1]) <: RealVector && typeof(args[2]) <: RealVector
        return args
    else
        throw(MethodError(mtd, args))
    end
end

# ROC curve
@userplot ROCCurve

@recipe function f(h::ROCCurve)
    seriestype := :mlcurve
    diagonal   --> true
    title      --> "ROC curve"
    _get_arguments(roccurve, h.args, false_positive_rate, true_positive_rate)

end

Plots.@deps ROCCurve


# Precision-Recall curve
@userplot PRCurve

@recipe function f(h::PRCurve)
    seriestype := :mlcurve
    title      --> "Precision-Recall curve"
    _get_arguments(prcurve, h.args, recall, precision)
end

Plots.@deps PRCurve


# Precision-quantile curve
@userplot PQuantCurve

@recipe function f(h::PQuantCurve; rev = true)
    seriestype := :mlcurve
    title      --> "Precision-Quantile curve"
    ylabel     --> "quantile"
    _get_arguments(pquantcurve, h.args, quant, precision)
end

Plots.@deps PQuantCurve


# Recall-quantile curve
@userplot RQuantCurve

@recipe function f(h::RQuantCurve; rev = true)
    seriestype := :mlcurve
    title      --> "Recall-Quantile curve"
    ylabel     --> "quantile"
    _get_arguments(rquantcurve, h.args, quant, recall)
end

Plots.@deps RQuantCurve