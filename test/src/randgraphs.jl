using Graphs
type Edge
    src::Integer
    dst::Integer
end

function randgraph(nv::Integer, ne::Integer=10*nv, f::AbstractString="graph-$nv-$ne.csv")
    edges = Edge[]
    f = open(f,"w")
    line = string(nv,"\n")
    write(f,line)
    i = 1
    while i <= ne
        source = rand(1:nv)
        dest = rand(1:nv)
        e = Edge(source, dest)
        if (source != dest) && !(in(e, edges))
            i+= 1
            line = string(source,", ", dest,"\n")
            write(f,line)
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
