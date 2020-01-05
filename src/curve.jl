function _get_annotation(x::Real, y::Real, fontsize::Int)
    txt = "($(join(round.([x, y], digits = 2), ", ")))"
    return (x, y + 0.035, text(txt, fontsize))
end


@recipe function f(::Type{Val{:points}}, x, y, z; customcolor = :auto, coordinates = true)
    if coordinates
        annotations := _get_annotation.(x, y, 8)
    end
    seriestype        := :scatter
    markercolor       := customcolor
    markerstrokecolor := customcolor
    x                 := x
    y                 := y
    ()
end


@recipe function f(::Type{Val{:aucbox}}, x, y, z; percent = true)
    val = EvalMetrics.auc(x,y)
    if percent
        txt = "auc = $(round(100*val, digits = 2))%"
    else
        txt = "auc = $(round(val, digits = 2))"
    end
    annotations := (0.5, 0.025, text(txt, 8))
    seriestype  := :shape
    linecolor   := :black
    fill        := (0, :white)
    x           := [0.4, 0.6, 0.6, 0.4, 0.4]
    y           := [0, 0, 0.05, 0.05, 0]
    ()
end


@recipe function f(::Type{Val{:diagonal}}, x, y, z)
    seriestype  := :path
    linecolor   := :red
    linestyle   := :dash
    x           := [0, 1]
    y           := [0, 1]
    ()
end


@recipe function f(::Type{Val{:curve}}, x, y, z; indexes     = Int[],
                                                 xrev        = false,
                                                 yrev        = false,
                                                 showauc     = true,
                                                 coordinates = true,
                                                 percent     = true,
                                                 diag        = false)

    color_ind = plotattributes[:plot_object].n
    grid   := true
    legend := false
    xlims  := (0, 1.01)
    ylims  := (0, 1.01)
    xticks := (0:0.25:1, ["0", "0.25", "0.5", "0.75", "1"])
    yticks := (0:0.25:1, ["0", "0.25", "0.5", "0.75", "1"])

    xrev && reverse!(x)
    yrev && reverse!(y)
    
    @series begin
        seriestype := :path
        color      := color_ind
        x          := x
        y          := y
        ()
    end 

    @series begin
        seriestype  := :points
        coordinates := coordinates
        customcolor := color_ind
        x           := x[indexes]
        y           := y[indexes]
        ()
    end 

    if showauc
        @series begin
            seriestype := :aucbox
            percent    := percent
            x          := x
            y          := y
            ()
        end 
    end

    if diag
        @series begin
            seriestype := :diagonal
            x          := x
            y          := y
            ()
        end 
    end
end

Plots.@deps points aucbox curve 