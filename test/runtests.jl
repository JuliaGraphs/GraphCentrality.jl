using Centrality
using Base.Test

tests = [
    "measures/degree",
    "measures/betweenness",
    "measures/closeness",
]


for t in tests
    tp = joinpath(Pkg.dir("Centrality"),"test","$(t).jl")
    println("running $(tp) ...")
    include(tp)
end
