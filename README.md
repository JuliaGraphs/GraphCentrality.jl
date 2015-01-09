# Centrality.jl

[![Build Status](https://travis-ci.org/sbromberger/Centrality.jl.svg?branch=master)](https://travis-ci.org/sbromberger/Centrality.jl)

Optimized, performance-driven centrality measures on [Graphs.jl](https://github.com/JuliaLang/Graphs.jl) graphs.


| Centrality Test | (order, size)   | Centrality.jl   | NetworkX      | Improvement |
|:-------------:  |:-------------:  | -------------:  | -------------:| ----------: |
|degree           | (1e6, 1e7)      | 0.30s           | 30.7s         | 99%         |
|betweenness      | (500, 5000)     | 4.32s           | 9.11s         | 52%         |
|closeness        | (1000, 80000)   | 2.18s           | 12.1s         | 77%         |


##TODO
- [X] Finish betweenness_centrality with dijkstra
- [X] Optimize code
- [ ] TESTS!
- [ ] New centrality measures:
 - [X] Closeness
 - [ ] Load
 - [ ] Eigenvector
 - [ ] Current flow betweenness?
 - [ ] Current flow closeness?
