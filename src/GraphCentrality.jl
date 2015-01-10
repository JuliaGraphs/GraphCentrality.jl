module GraphCentrality
    using Graphs
    using DataStructures
    using StatsBase
    using Compat

    g = simple_graph(2)
    if !applicable(dijkstra_shortest_paths, g, 1)
        import Graphs.dijkstra_shortest_paths
        dijkstra_shortest_paths{V}(graph::AbstractGraph{V}, s::V) =
            dijkstra_shortest_paths(graph, ones(num_edges(graph)), s)
    end
    export
        dijkstra_predecessor_and_distance!, dijkstra_predecessor_and_distance,

        degree_centrality, in_degree_centrality, out_degree_centrality,
        betweenness_centrality, closeness_centrality

    include("dijkstra_pred.jl")
    include("measures/degree.jl")
    include("measures/betweenness.jl")
    include("measures/closeness.jl")
    include("randgraphs.jl")

end # module
