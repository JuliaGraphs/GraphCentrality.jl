function closeness_centrality{V}(
    g::AbstractGraph{V};
    normalize=true,
    weights=Float64[])

    nv = num_vertices(g)
    closeness = zeros(nv)

    for ui = 1:num_vertices(g)
        u = g.vertices[ui]
        d = dijkstra_shortest_paths(g,u).dists
        δ = d[!isinf(d)]
        σ = sum(δ)
        l = length(δ) - 1
        if σ > 0
            closeness[ui] = l / σ

            if normalize
                n = l / (nv-1)
                closeness[ui] *= n
            end
        end
    end
    return closeness
end
