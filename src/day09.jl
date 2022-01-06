#!/usr/bin/julia

# Copyright (C) 2021, 2022 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Nine, Smoke Basin."


#= At first I left this day uncompleted because I lacked the graph theory
 = knowledge to solve part two; but after learning the Dijkstra’s algorithm for
 = day fifteen, I managed to solve this problem in a similar way.
 =#

include("Utils.jl")

using .Utils

"Calculate the sum of the risk levels of all low points in `heightmap`."
function solve1(heightmap :: Matrix{Int})
    risklevel_count = 0

    for ind in CartesianIndices(heightmap)
        neighbors = find_neighbors(heightmap, ind.I)

        if heightmap[ind] < minimum([heightmap[n...] for n in neighbors])
            risklevel_count += heightmap[ind] + 1
        end
    end

    return risklevel_count
end

"Calculate the product of the size of the three largest basins in `heightmap`."
function solve2(heightmap :: Matrix{Int})
    # Mark all locations with height nine as visited.
    unvisited = BitArray{2}([row .!= 9 for row in heightmap])

    current = (1, 1)
    next = Array{Tuple{Int, Int}}([])

    basins = Array{Int}([])
    current_basin = 0

    while count(unvisited) != 0
        unvisited[current...] = false
        current_basin += 1

        neighbors = find_neighbors(heightmap, current)

        filter!(x -> unvisited[x...] && x ∉ next, neighbors)
        push!(next, neighbors...)

        if isempty(next)
            push!(basins, current_basin)
            current_basin = 0

            if count(unvisited) != 0
                current = findfirst(unvisited).I
            end
        else
            current = pop!(next)
        end
    end

    return prod(sort(basins)[end - 2:end])
end

function main()
    usage_and_exit(length(ARGS) != 1)

    data = collect.(readlines(first(ARGS)))
    heightmap = hcat([parse.(Int, l) for l in data]...)

    println(solve1(heightmap))
    println(solve2(heightmap))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
