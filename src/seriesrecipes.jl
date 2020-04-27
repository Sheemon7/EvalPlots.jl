# -------------------------------------------------------------------------------
# mlcurve series
# -------------------------------------------------------------------------------
function isdefault(plotattributes, key::Symbol)
    !haskey(plotattributes, key) || plotattributes[key] == default(key)
end


function auc_label(x, y, inpercent::Bool = false)
    val = auc(x,y)
    if inpercent
        string("auc: ", round(100*val, digits = 2), "%")
    else
        string("auc: ", round(val, digits = 2))
    end
end


@recipe function f(::Type{Val{:mlcurve}}, x, y, z; indexes   = Int[],
                                                   aucshow   = true,
                                                   inpercent = true,
                                                   diagonal  = false)

    # Set attributes
    grid  --> true
    lims  --> (0, 1.01)

    # Add auc to legend
    if aucshow
        if isdefault(plotattributes, :label)
            label := auc_label(x, y, inpercent)
        else
            label := string(plotattributes[:label], " (", auc_label(x, y, inpercent), ")")
        end
    end

    # main curve
    @series begin
        seriestype := :path
        marker     := :none
        x          := x
        y          := y
        ()
    end

    # points on the main curve
    @series begin
        primary           := false
        seriestype        := :scatter
        markerstrokecolor := :auto
        label             := ""
        x                 := x[indexes]
        y                 := y[indexes]
        ()
    end 

    # diagonal
    if diagonal
        @series begin
            primary    := false
            seriestype := :path
            fill       := false
            line       := (:red, :dash, 0.5)
            marker     := :none
            label      := ""
            x          := [0, 1]
            y          := [0, 1]
            ()
        end 
    end
end


@shorthands mlcurve
Plots.@deps mlcurve