using GraphCentrality
using Base.Test

tests = [
    "randgraphs",
    "measures/degree",
    "measures/betweenness",
    "measures/closeness",
]


for t in tests
    tp = joinpath(Pkg.dir("GraphCentrality"),"test","$(t).jl")
    println("running $(tp) ...")
    include(tp)
end
