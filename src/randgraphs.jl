# These are test functions only, used for consistent centrality comparisons.
using Graphs
immutable REdge
    src::Integer
    dst::Integer
end

function randgraph(nv::Integer, ne::Integer=int(0.2*(nv^2)), f::AbstractString="graph-$nv-$ne.csv")
    redges = Set(REdge[])
    f = open(f,"w")
    line = string(nv,"\n")
    write(f,line)
    i = 1
    while i <= ne
        source = rand(1:nv)
        dest = rand(1:nv)
        e = REdge(source, dest)
        if (source != dest) && !(in(e,redges))
            i+= 1
            line = string(source,", ", dest,"\n")
            write(f,line)
            push!(redges,e)
        end
    end
    close(f)
end

function readgraph(f::AbstractString)
    f = open(f,"r")
    line = chomp(readline(f))
    n = int(line)
    g = simple_graph(n)
    while !eof(f)
        line = chomp(readline(f))
        src_s,dst_s = split(line,',')
        src = int(src_s)
        dst = int(dst_s)
        add_edge!(g,src,dst)
    end
    close(f)
    return g
end

function readcentrality(f::AbstractString)
    f = open(f,"r")
    c = Float64[]
    while !eof(f)
        line = chomp(readline(f))
        push!(c, float(line))
    end
    return c
end
