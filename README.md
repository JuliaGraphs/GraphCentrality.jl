# GraphCentrality.jl

[![Build Status](https://travis-ci.org/JuliaGraphs/GraphCentrality.jl.svg?branch=master)](https://travis-ci.org/JuliaGraphs/GraphCentrality.jl)
[![Coverage Status](https://img.shields.io/coveralls/JuliaGraphs/GraphCentrality.jl.svg)](https://coveralls.io/r/JuliaGraphs/GraphCentrality.jl?branch=master)

Optimized, performance-driven centrality measures on [Graphs.jl](https://github.com/JuliaLang/Graphs.jl) graphs.


#### Please note that this package is not actively maintained. Active development of centrality measures has been moved to the [LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl) project. 


| Centrality Test | (order, size)   | GraphCentrality.jl   | NetworkX      | Improvement |
|:-------------:  |:-------------:  | -------------:       | -------------:| ----------: |
|degree           | (1e6, 1e7)      | 0.30s                | 30.7s         | 99%         |
|betweenness      | (500, 50000)    | 4.25s                | 9.13s         | 53%         |
|closeness        | (1000, 80000)   | 2.18s                | 12.1s         | 77%         |


#### TODO
- [X] Finish betweenness_centrality with dijkstra
- [X] Optimize code
- [X] TESTS!
- [ ] New centrality measures:
 - [X] Closeness
 - [ ] Load
 - [ ] Eigenvector
 - [ ] Current flow betweenness?
 - [ ] Current flow closeness?
