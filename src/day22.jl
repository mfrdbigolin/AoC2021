#!/usr/bin/julia

# Copyright (C) 2022 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Twenty-Two, Reactor Reboot."


# u/ai_prof’s solution on Reddit really helped me today.

#= This was the best time I could manage today.  As I’m really busy, and don’t
 = have time to over-optimize the solutions, I will leave this day as it is.
 =#

include("Utils.jl")

using .Utils

const Cubes = Tuple{Int, Tuple{Int, Int, Int}, Tuple{Int, Int, Int}}

"Find the intersection between `A` and `B`."
function intersect(A :: Cubes, B :: Cubes)
    R = (-B[1], max.(A[2], B[2]), min.(A[3], B[3]))

    return if any((>).(R[2:end]...)) nothing else R end
end

"Given the `cuboids`, find the total number of cubes lit at the end."
function solve(cuboids :: Array{Cubes})
    cores = []

    for cub in cuboids
        next = Array{Cubes}(first(cub) == 1 ? [cub] : [])

        for core in cores
            inter = intersect(cub, core)

            if !isnothing(inter)
                push!(next, inter)
            end
        end

        push!(cores, next...)
    end

    oncount = 0

    for (t, C₀, C₁) in cores
        Δx, Δy, Δz = @. (-)(C₁, C₀) + 1

        oncount += prod([t, Δx, Δy, Δz])
    end

    return oncount
end

const CUBS_REX = r"(?:(on|off)|([-]?\d+))"

function main()
    usage_and_exit(length(ARGS) != 1)

    data = readlines(first(ARGS))
    cubs = [[filter(!isnothing, m.captures)[1] for m in eachmatch(CUBS_REX, l)] for l in data]

    reboot = [(Int(i == "on"), parse.(Int, (x₀, y₀, z₀)), parse.(Int, (x₁, y₁, z₁))) for (i, x₀, x₁, y₀, y₁, z₀, z₁) in cubs]

    in_init = pos -> all(map(in(-50:50), pos))
    init = filter(x -> in_init(x[2]) && in_init(x[3]), reboot)

    println(solve(init))
    println(solve(reboot))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
