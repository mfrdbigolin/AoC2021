#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Eleven, Dumbo Octopus."


include("Utils.jl")

using .Utils

"Perform a step and update the `octopuses` energy grid."
function update_octopuses!(octopuses :: Matrix{Int})
    new_energy = ones(Int, size(octopuses))
    flashed = Set{CartesianIndex{2}}([])

    has_flashed = true
    while has_flashed
        has_flashed = false

        for ind in CartesianIndices(octopuses)
            if octopuses[ind] + new_energy[ind] >= 10 && ind ∉ flashed
                push!(flashed, ind)
                has_flashed = true

                neighbors = find_all_neighbors(octopuses, ind.I)
                [new_energy[neighbor...] += 1 for neighbor in neighbors]
            end
        end
    end

    octopuses .+= new_energy

    [octopuses[i] = 0 for i in flashed]

    return length(flashed)
end

"Calculate the number of all `octopuses`’ flashes up to `steps`."
function solve1(octopuses :: Matrix{Int}, steps :: Int)
    octs = copy(octopuses)
    flashes = 0

    for _ in 1:steps
        flashes += update_octopuses!(octs)
    end

    return flashes
end

"Return the first step that all `octopuses` flash together."
function solve2(octopuses :: Matrix{Int})
    octs = copy(octopuses)
    step = 1

    while update_octopuses!(octs) != length(octs)
        step += 1
    end

    return step
end

function main()
    usage_and_exit(length(ARGS) != 1)

    data = readlines(first(ARGS))

    octopuses = hcat([parse.(Int, e) for e in collect.(data)]...)

    println(solve1(octopuses, 100))
    println(solve2(octopuses))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
