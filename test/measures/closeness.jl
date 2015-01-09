using Graphs
h = graph(["a","b","c","d"],[])
add_edge!(h,"a","b"); add_edge!(h,"b","c"); add_edge!(h,"a","c"); add_edge!(h,"c","d")
z = closeness_centrality(h)
@test z == [0.75, 0.4444444444444444, 0.3333333333333333, 0.0]
