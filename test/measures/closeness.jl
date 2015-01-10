h = graph(["a","b","c","d"],Edge{ASCIIString}[])
add_edge!(h,"a","b"); add_edge!(h,"b","c"); add_edge!(h,"a","c"); add_edge!(h,"c","d")
z = closeness_centrality(h, normalize=false)
@test z == [0.75, 0.6666666666666666, 1.0, 0.0]
y = closeness_centrality(h)
@test y == [0.75, 0.4444444444444444, 0.3333333333333333, 0.0]
