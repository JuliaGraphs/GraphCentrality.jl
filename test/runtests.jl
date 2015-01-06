using Centrality
using Base.Test

# write your own tests here
@test 1 == 1

# betweeenness centrality - values taken from networkx
g = Centrality.readgraph("testdata/graph-50-500.csv")
c = Centrality.readcentrality("testdata/graph-50-500-c.txt")
z = betweenness_centrality(g)
@test float32(z) == float32(c)
