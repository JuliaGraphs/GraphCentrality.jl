# betweeenness centrality - values taken from networkx
g = Centrality.readgraph("testdata/graph-50-500.csv")
c = Centrality.readcentrality("testdata/graph-50-500-bc.txt")
z = betweenness_centrality(g)
@test float32(z) == float32(c)
