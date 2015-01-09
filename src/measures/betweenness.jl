using DataStructures
using StatsBase

function betweenness_centrality{V}(
    g::AbstractGraph{V},
    k::Integer=0;
    normalized=true,
    endpoints=false,
    weights=Float64[])

    betweenness = Dict{V, Float64}()
    for v in vertices(g)
        betweenness[v] = 0.0
    end
    if k == 0
        nodes = vertices(g)
    else
        nodes = sample(vertices(g), k, replace=false)   #112
    end
    for s in nodes
        if length(weights) == 0
            S, P, σ = _single_source_shortest_path_basic(g, s)
        else
            S, P, σ = _single_source_dijkstra_path_basic(g, s, weights)
        end
        if endpoints            # 120
            betweenness = _accumulate_endpoints(betweenness, S, P, σ, s)
        else
            betweenness = _accumulate_basic(betweenness, S, P, σ, s)
        end
    end
    betweenness = _rescale(betweenness, num_vertices(g),
                           normalized,
                           is_directed(g),
                           k)

    byvind = zeros(num_vertices(g))
    for (k,v) in betweenness
        byvind[vertex_index(k,g)] = v
    end
    return byvind
end




function _single_source_shortest_path_basic{V}(g::AbstractGraph{V}, s::V)
    S = V[]

    P = Dict{V, Vector{V}}()
    σ = Dict{V, Float64}()
    for v in vertices(g)
        P[v] = V[]
        σ[v] = 0.0
    end
    D = Dict{V, Int}()  #222
    σ[s] = 1.0

    D[s] = 0

    Q = V[s] # 225

    while length(Q) > 0
        v = shift!(Q)   #227
        push!(S,v)  #228
        Dv = D[v]
        σv = σ[v]
        for w in out_neighbors(v,g)
            if !(w in keys(D))
                push!(Q,w)
                D[w] = Dv + 1   # 234
            end
            if D[w] == Dv + 1
                σ[w] += σv
                push!(P[w], v)
            end
        end
    end
    return S, P, σ
end

function _single_source_dijkstra_path_basic{V}(g::AbstractGraph{V}, s::V, weights::Vector{Float64})
    S = V[]

    P = Dict{V, Vector{V}}()
    σ = Dict{V, Float64}()
    for v in vertices(g)
        P[v] = V[]
        σ[v] = 0.0
    end
    D = Dict{V, Float64}()
    σ[s] = 1.0

    seen = Dict{V,Float64}()
    seen[s] = 0
    c = 0 # 253
    Q = (Float64, Int, V, V)[]
    push!(Q, (0.0, c, s, s)); c += 1
    while length(Q) > 0
        (dist, _, pred, v) = pop!(Q)
        if (v in keys(D)) # 258
            continue
        end
        σ[v] += σ[pred]
        push!(S,v)
        D[v] = dist
        for w in out_neighbors(v,g)
            wi = vertex_index(w,g)
            vw_dist = dist + weights[wi] # 264
            if !(w in keys(D)) && ((!(w in keys(seen))) || (vw_dist < seen[w]))
                seen[w] = vw_dist
                push!(Q, (vw_dist, c, v, w)); c += 1
                σ[w] = 0.0
                P[w] = [v]
            elseif vw_dist == seen[w] # 270
                σ[w] += σ[v]
                push!(P[w],v)
            end
        end
    end
    return S, P, σ
end


function _accumulate_basic{V}(
    betweenness::Dict{V, Float64},
    S::Vector{V},
    P::Dict{V, Vector{V}},
    σ::Dict{V, Float64},
    s::V
    )
    disps = zeros(Float64,length(σ))
    dispp = zeros(Int,length(P))
    for (k,v) in σ
        disps[k] = v
    end
    for (k,v) in P
        if length(v) > 0
            dispp[k] = v[1]
        end
    end

    println("S = $S, P = $P, σ = $disps, s = $s")
    δ = Dict{V, Float64}()
    for i in S
        δ[i] = 0.0
    end


    while length(S) > 0
        w = pop!(S) # 279
        coeff = (1.0 + δ[w]) / σ[w]
        # println("coeff of $w = $coeff, δ[w] = $(δ[w])")
        # println("*** P[w] = P[$w] = $(P[w])")
        for v in P[w]
            δ[v] += (σ[v] * coeff)
            # println("setting δ[$v] to $(δ[v])")
        end
        if w != s
            betweenness[w] += δ[w]
        end
    end
    byvind = zeros(length(betweenness))
    for (k,v) in betweenness
        byvind[k] = v
    end
    println("betweenness = $byvind")
    return betweenness
end

function _accumulate_endpoints{V}(
    betweenness::Dict{V, Float64},
    S::Vector{V},
    P::Dict{V, Vector{V}},
    σ::Dict{V, Float64},
    s::V
    )

    betweenness[s] += length(S) - 1    # 289
    δ = Dict{V, Float64}()
    for i in S
        δ[i] = 0.0
    end

    while length(S) > 0
        w = pop!(S) # 292
        coeff = (1.0 + δ[w]) / σ[w]
        for v in P[w]
            δ[v] += σ[v] * coeff
        end
        if w != s
            betweenness[w] += (δ[w] + 1)
        end
    end
    return betweenness
end

function _rescale{V}(betweenness::Dict{V, Float64}, n::Int, normalized::Bool, directed::Bool, k::Int)
    if normalized
        if n <= 2
            do_scale = false
        else
            do_scale = true
            scale = 1.0 / ((n - 1) * (n - 2))
        end
    else
        if !directed
            do_scale = true
            scale = 1.0 / 2.0
        else
            do_scale = false    # 328
        end
    end
    if do_scale
        if k > 0
            scale = scale * n / k   #331
        end
        for v in keys(betweenness)
            betweenness[v] *= scale
        end
    end
    return betweenness      # 334
end
