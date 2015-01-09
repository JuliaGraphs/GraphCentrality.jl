using Graphs
h = graph(["a","b","c","d"],[])
add_edge!(h,"a","b"); add_edge!(h,"b","c"); add_edge!(h,"a","c"); add_edge!(h,"c","d")

@test degree_centrality(h, normalize=false) == [2.0, 2.0, 3.0, 1.0]
@test in_degree_centrality(h, normalize=false) == [0.0, 1.0, 2.0, 1.0]
@test out_degree_centrality(h; normalize=false) == [2.0, 1.0, 1.0, 0.0]
