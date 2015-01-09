import  Graphs.TrivialDijkstraVisitor,
        Graphs.DijkstraHEntry,
        Graphs.include_vertex!


abstract AbstractDijkstraStates
###################################################################
#
#   dijkstra_predecessor_and_distance functions
#
###################################################################

# This DijkstraState tracks predecessors and path counts
type DijkstraStatesWithPred{V,D<:Number,Heap,H} <: AbstractDijkstraStates
    parents::Vector{V}
    hasparent::Vector{Bool}
    dists::Vector{D}
    colormap::Vector{Int}
    pathcounts::Vector{Int}
    predecessors::Vector{Vector{V}}
    heap::Heap
    hmap::Vector{H}
end

# Create Dijkstra state that tracks predecessors and path counts
function create_dijkstra_states_with_pred{V,D<:Number}(g::AbstractGraph{V}, ::Type{D})
    n = num_vertices(g)
    parents = Array(V, n)
    hasparent = fill(false, n)
    dists = fill(typemax(D), n)
    colormap = zeros(Int, n)
    pathcounts = zeros(Int, n)
    predecessors = Array(Vector{V}, n)
    heap = mutable_binary_minheap(DijkstraHEntry{V,D})
    hmap = zeros(Int, n)

    for i = 1:n
        predecessors[i] = []
    end
    DijkstraStatesWithPred(parents, hasparent, dists, colormap, pathcounts, predecessors, heap, hmap)
end

function set_source_with_pred!{V,D}(state::DijkstraStatesWithPred{V,D}, g::AbstractGraph{V}, s::V)
    i = vertex_index(s, g)
    state.parents[i] = s
    state.hasparent[i] = true
    state.dists[i] = 0
    state.colormap[i] = 2
    state.pathcounts[i] = 1
    state.predecessors[i] = [s]
end

function process_neighbors_with_pred!{V,D,Heap,H}(
    state::DijkstraStatesWithPred{V,D,Heap,H},
    graph::AbstractGraph{V},
    edge_dists::AbstractEdgePropertyInspector{D},
    u::V, du::D, visitor::AbstractDijkstraVisitor)

    dists::Vector{D} = state.dists
    parents::Vector{V} = state.parents
    hasparent::Vector{Bool} = state.hasparent
    colormap::Vector{Int} = state.colormap
    pathcounts::Vector{Int} = state.pathcounts              # the # of paths from src to the vertex
    predecessors::Vector{Vector{V}} = state.predecessors    # the vertex's predecessors
    heap::Heap = state.heap
    hmap::Vector{H} = state.hmap
    dv::D = zero(D)

    for e in out_edges(u, graph)
        v::V = target(e, graph)
        iv::Int = vertex_index(v, graph)
        v_color::Int = colormap[iv]

        if v_color == 0
            dists[iv] = dv = du + edge_property(edge_dists, e, graph)
            parents[iv] = u
            hasparent[iv] = true
            colormap[iv] = 1
            discover_vertex!(visitor, u, v, dv)
            # increment pathcounts and add to predecessors
            iu = vertex_index(u, graph)
            # this ensures that changed pathcounts propagate
            pathcounts[iv] += pathcounts[iu]
            predecessors[iv] = [u]


            # push new vertex to the heap
            hmap[iv] = push!(heap, DijkstraHEntry(v, dv))

        elseif v_color == 1
            dv = du + edge_property(edge_dists, e, graph)
            if dv < dists[iv]
                dists[iv] = dv
                parents[iv] = u
                hasparent[iv] = true

                # update the value on the heap
                update_vertex!(visitor, u, v, dv)
                update!(heap, hmap[iv], DijkstraHEntry(v, dv))
            elseif (dv == dists[iv])
                # increment pathcounts
                iu = vertex_index(u, graph)
                pathcounts[iv] += pathcounts[iu]
                push!(predecessors[iv], u)
            end
        end
    end
end

function dijkstra_predecessor_and_distance!{V, D, Heap, H}(
    graph::AbstractGraph{V},                # the graph
    edge_dists::AbstractEdgePropertyInspector{D}, # distances associated with edges
    sources::AbstractVector{V},             # the sources
    visitor::AbstractDijkstraVisitor,       # visitor object
    state::DijkstraStatesWithPred{V,D,Heap,H}      # the states
    )

    @graph_requires graph incidence_list vertex_map vertex_list
    edge_property_requirement(edge_dists, graph)

    # get state fields

    parents::Vector{V} = state.parents
    dists::Vector{D} = state.dists
    colormap::Vector{Int} = state.colormap
    heap::Heap = state.heap
    hmap::Vector{H} = state.hmap

    # initialize for sources

    d0 = zero(D)

    for s in sources
        set_source_with_pred!(state, graph, s)
        if !include_vertex!(visitor, s, s, d0)
            return state
        end
    end

    # process direct neighbors of all sources

    for s in sources
        process_neighbors_with_pred!(state, graph, edge_dists, s, d0, visitor)
        close_vertex!(visitor, s)
    end

    # main loop

    while !isempty(heap)

        # pick next vertex to include
        entry = pop!(heap)
        u::V = entry.vertex
        du::D = entry.dist

        ui = vertex_index(u, graph)
        colormap[ui] = 2
        if !include_vertex!(visitor, parents[ui], u, du)
            return state
        end

        # process u's neighbors

        process_neighbors_with_pred!(state, graph, edge_dists, u, du, visitor)
        close_vertex!(visitor, u)
    end

    state
end

function dijkstra_predecessor_and_distance{V, D}(
    graph::AbstractGraph{V},                # the graph
    edge_len::AbstractEdgePropertyInspector{D}, # distances associated with edges
    sources::AbstractVector{V};
    visitor::AbstractDijkstraVisitor=TrivialDijkstraVisitor())
    state::DijkstraStateWithPred = create_dijkstra_states_with_pred(graph, D)
    dijkstra_shortest_paths!(graph, edge_len, sources, visitor, state)
end

function dijkstra_predecessor_and_distance{V,D}(
    graph::AbstractGraph{V}, edge_dists::Vector{D}, s::V;
    visitor::AbstractDijkstraVisitor=TrivialDijkstraVisitor())

    edge_len::AbstractEdgePropertyInspector{D} = VectorEdgePropertyInspector(edge_dists)
    state = create_dijkstra_states_with_pred(graph, D)
    dijkstra_predecessor_and_distance!(graph, edge_len, [s], visitor, state)
end

dijkstra_predecessor_and_distance{V}(graph::AbstractGraph{V}, s::V) =
    dijkstra_predecessor_and_distance(graph, ones(num_edges(graph)), s)
