@test GraphCentrality.randgraph(10,10,STDOUT) == (10,10)
@test GraphCentrality.randgraph(10,10,"/dev/null") == (10,10)
