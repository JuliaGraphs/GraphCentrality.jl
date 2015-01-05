using DataStructures
using StatsBase

function _degree_centrality{V}(g::AbstractGraph{V}, gtype::Integer; normalize=true)
   nv = num_vertices(g)
   c = zeros(nv)
   for v in vertices(g)
       if gtype == 0    # count both in and out degree if appropriate
           deg = out_degree(v,g) + (is_directed(g)? in_degree(v,g) : 0)
       elseif gtype == 1    # count only in degree
           deg = in_degree(v,g)
       else                 # count only out degree
           deg = out_degree(v,g)
       end
       s = normalize? (1.0 / (nv - 1.0)) : 1.0
       println("v = $v")
       c[v] = deg*s
   end
   return c
end

degree_centrality(g; all...) = _degree_centrality(g, 0; all...)
in_degree_centrality(g; all...) = _degree_centrality(g, 1; all...)
out_degree_centrality(g; all...) = _degree_centrality(g, 2; all...)
