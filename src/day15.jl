#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Fifteen, Chiton."


include("Utils.jl")

# N.b.: external package, used for the PriorityQueue data structure.
using DataStructures

using DelimitedFiles
using .Utils

"Find the <cavern> path with the lowest risk; then, return this total risk."
function solve(cavern :: Array{Int8, 2}) :: Int
    sizepaths = size(cavern)

    unvisited = [(i,j) for j in 1:sizepaths[2] for i in 1:sizepaths[1]]

    distance = PriorityQueue(zip(unvisited, fill(Inf, length(cavern))))
    distance[(1,1)] = 0

    current = (1,1)

    # Dijkstra’s algorithm.
    while current != sizepaths
        i, j = current
        neighbors = Array{Tuple{Int64, Int64}}([])

        for idx in [(i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1)]
            idxs = CartesianIndices(cavern)
            if CartesianIndex(idx) in idxs && idx in keys(distance)
                push!(neighbors, idx)
            end
        end

        for neighbor in neighbors
            rel_dist = cavern[neighbor...] + peek(distance)[2]
            if rel_dist < distance[neighbor]
                distance[neighbor] = rel_dist
            end
        end

        dequeue!(distance)

        current = peek(distance)[1]
    end

    return distance[sizepaths]
end

"Enlarge <cavern> to its actual dimension."
function enlarge(cavern :: Array{Int8, 2}) :: Array{Int8, 2}
    pattern = reshape([Int8(i + j) for i in 0:4 for j in 0:4], (5,5))

    enlarged_pattern = repeat(pattern, inner=size(cavern))
    repeated_cavern = repeat(cavern, 5, 5)

    return [Int8(mod1(i, 9)) for i in repeated_cavern + enlarged_pattern]
end

function main()
    usage_and_exit(length(ARGS) != 1)

    data = collect.(readdlm(first(ARGS), String))

    cavern = hcat([parse.(Int8, path) for path in data]...)
    large_cavern = enlarge(cavern)

    println(solve(cavern))
    println(solve(large_cavern))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
