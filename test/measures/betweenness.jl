# betweeenness centrality - values taken from networkx
g = GraphCentrality.readgraph("testdata/graph-50-500.csv")
h = graph(["a","b","c","d"],Edge{ASCIIString}[], is_directed=false)
add_edge!(h,"a","b"); add_edge!(h,"b","c"); add_edge!(h,"a","c"); add_edge!(h,"c","d")

c = GraphCentrality.readcentrality("testdata/graph-50-500-bc.txt")
z = betweenness_centrality(g)
@test float32(z) == float32(c)
y = betweenness_centrality(g, endpoints=true, normalize=false)
@test y[1:3] == [122.10760591498584, 159.0072453120582, 176.39547945994505]
x = betweenness_centrality(g,3)
@test length(x) == 50
w = betweenness_centrality(h, normalize=false)
@test w == [ 0.0, 0.0, 2.0, 0.0 ]
