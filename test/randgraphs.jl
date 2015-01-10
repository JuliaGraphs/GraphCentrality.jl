@test Centrality.randgraph(10,10,STDOUT) == (10,10)
@test Centrality.randgraph(10,10,"/dev/null") == (10,10)
