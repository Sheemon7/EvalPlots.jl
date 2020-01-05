function _get_coordinates(x::Real, y::Real, fontsize::Int)
    txt = "($(join(round.([x, y], digits = 2), ", ")))"
    return (x, y + 0.035, text(txt, fontsize))
end


function _get_auc(x::RealVector, y::RealVector, fontsize::Int, percent::Bool)
    val = auc(x,y)
    if percent
        txt = "auc = $(round(100*val, digits = 2))%"
    else
        txt = "auc = $(round(val, digits = 2))"
    end
    return (0.5, 0.025, text(txt, fontsize))
end


@recipe function f(::Type{Val{:mlcurve}}, x, y, z; indexes     = Int[],
                                                   xrev        = false,
                                                   yrev        = false,
                                                   showauc     = true,
                                                   coordinates = true,
                                                   percent     = true,
                                                   diag        = false)

    xrev && reverse!(x)
    yrev && reverse!(y)
    
    annots = Tuple[]
    coordinates && append!(annots, _get_coordinates.(x[indexes], y[indexes], 8))
    showauc     && push!(annots, _get_auc(x, y, 8, percent))

    color_ind = plotattributes[:plot_object].n

    grid   := true
    legend := false
    xlims  := (0, 1.01)
    ylims  := (0, 1.01)
    xticks := (0:0.25:1, ["0", "0.25", "0.5", "0.75", "1"])
    yticks := (0:0.25:1, ["0", "0.25", "0.5", "0.75", "1"])

    @series begin
        seriestype        := :scatter
        markercolor       := color_ind
        markerstrokecolor := color_ind
        x                 := x[indexes]
        y                 := y[indexes]
        ()
    end 

    if showauc
        @series begin
            seriestype  := :shape
            linecolor   := :black
            fillcolor   := :white
            x           := [0.4, 0.6, 0.6, 0.4, 0.4]
            y           := [0, 0, 0.05, 0.05, 0]
            ()
        end 
    end

    if diag
        @series begin
            seriestype  := :path
            linecolor   := :red
            linestyle   := :dash
            x           := [0, 1]
            y           := [0, 1]
            ()
        end 
    end

    @series begin
        seriestype  := :path
        color       := color_ind
        annotations := annots
        x           := x
        y           := y
        ()
    end 
end

Plots.@deps mlcurve