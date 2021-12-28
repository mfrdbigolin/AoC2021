#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Twelve, Passage Pathing."


#= The recursive solution works on a good time, therefore no need to use
 = dynamic programming, at least now.  Maybe I will return and refactor this
 = solution someday.
 =#

include("Utils.jl")

using DelimitedFiles
using .Utils

"Create adjacency matrix from `paths`."
function create_adjacency_matrix(paths :: Matrix{String})
    vertices = unique(paths)
    vert_len = length(vertices)

    vert_assoc = Dict(zip(vertices, 1:vert_len))
    path_assoc = zip(paths[:,1], paths[:,2])

    adj_mat = BitArray{2}(zeros(Bool, (vert_len, vert_len)))

    for path in path_assoc
        if "start" in path
            to = path[findfirst(path .!= "start")]
            adj_mat[vert_assoc["start"], vert_assoc[to]] = 1
        elseif "end" in path
            from = path[findfirst(path .!= "end")]
            adj_mat[vert_assoc[from], vert_assoc["end"]] = 1
        else
            from, to = path

            adj_mat[vert_assoc[from], vert_assoc[to]] = 1
            adj_mat[vert_assoc[to], vert_assoc[from]] = 1
        end
    end

    return adj_mat
end

"""Find the number of possible `paths` in the cavern system.  If `can_twice`,
allow at most two visits to a single small cave; if not, only allow one visit
per small cave."""
function solve(paths :: Matrix{String}, can_twice = false)
    vertices = unique(paths)

    vert_assoc = Dict(zip(vertices, 1:length(vertices)))
    adj_mat = create_adjacency_matrix(paths)

    small_cave = Array{Int}([])

    for v in vertices
        if all(islowercase.(collect(v))) && v ∉ ["start", "end"]
            push!(small_cave, vert_assoc[v])
        end
    end

    """Recurse through the paths, recording the small caves `visited` and the
    `start` point. For `can_twice`, vide supra."""
    function rec_path(can_twice = false, visited = [], start = vert_assoc["start"])
        if start == vert_assoc["end"]
            return 1
        elseif start in visited
            if !can_twice
                return 0
            else
                can_twice = false
            end
        end

        new_visited = visited

        if start in small_cave
            new_visited = copy(visited)
            push!(new_visited, start)
        end

        starts = findall(adj_mat[start,:])

        return sum([rec_path(can_twice, new_visited, st) for st in starts])
    end

    return rec_path(can_twice)
end

function main()
    usage_and_exit(length(ARGS) != 1)

    data = Matrix{String}(readdlm(first(ARGS), '-'))

    println(solve(data))
    println(solve(data, true))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
