function _get_coordinates(x::Real, y::Real, fontsize::Int)
    txt = "($(join(round.([x, y], digits = 2), ", ")))"
    return (x, y + 0.035, text(txt, fontsize))
end


function _get_auc(x::RealVector, y::RealVector, fontsize::Int, aucpercent::Bool)
    val = auc(x,y)
    if aucpercent
        txt = "auc = $(round(100*val, digits = 2))%"
    else
        txt = "auc = $(round(val, digits = 2))"
    end
    return (0.5, 0.02, text(txt, fontsize))
end


@recipe function f(::Type{Val{:mlcurve}}, x, y, z; indexes     = Int[],
                                                   coordinates = true,
                                                   aucshow     = true,
                                                   aucpercent  = true,
                                                   diagonal    = false)

    ## handle annotations
    annots = Tuple[]
    coordinates && append!(annots, _get_coordinates.(x[indexes], y[indexes], 8))
    aucshow     && push!(annots, _get_auc(x, y, 8, aucpercent))
    if haskey(plotattributes, :annotations)
        append!(plotattributes[:annotations], annots)
    else
        annotations := annots
    end

    ## Set attributes
    grid   --> true
    legend --> false
    label  --> ""
    xlims  --> (0, 1.01)
    ylims  --> (0, 1.01)
    xticks --> (0:0.25:1, ["0", "0.25", "0.5", "0.75", "1"])
    yticks --> (0:0.25:1, ["0", "0.25", "0.5", "0.75", "1"])

    @series begin
        seriestype  := :path
        marker      := :none
        x           := x
        y           := y
        ()
    end

    @series begin
        primary           := false
        seriestype        := :scatter
        label             := ""
        markerstrokecolor := :auto
        x                 := x[indexes]
        y                 := y[indexes]
        ()
    end 

    if aucshow
        @series begin
            seriestype  := :shape
            linecolor   := :black
            fillcolor   := :white
            label       := ""
            x           := [0.4, 0.6, 0.6, 0.4, 0.4]
            y           := [0, 0, 0.05, 0.05, 0]
            ()
        end 
    end

    if diagonal
        @series begin
            seriestype  := :path
            linecolor   := :grey
            linestyle   := :dash
            alpha       := 0.5
            label       := ""
            x           := [0, 1]
            y           := [0, 1]
            ()
        end 
    end
end

Plots.@deps mlcurve