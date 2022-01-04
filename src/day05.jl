#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Five, Hydrothermal Venture."


include("Utils.jl")

using LinearAlgebra
using .Utils

const Line = Tuple{Tuple{Int64, Int64}, Tuple{Int64, Int64}}

"Calculate the endpoints of the <line>."
function calculate_endpoints(line :: Line)
    x₀, x₁ = sort([first.(line)...]) .+ 1
    y₀, y₁ = sort([last.(line)...]) .+ 1

    return ((x₀, y₀), (x₁, y₁))
end

"Calculate the slope of the <line>"
function calculate_slope(line :: Line)
    x₀, x₁ = first.(line)
    y₀, y₁ = last.(line)

    return (y₁ - y₀)/(x₁ - x₀)
end

"Superimpose the <lines> over the <plane> and update it (mutating)."
function update_lines!(lines :: Array{Line}, plane :: Array{Int64, 2})
    for l in lines
        ((x₀, y₀), (x₁, y₁)) = calculate_endpoints(l)
        slope = calculate_slope(l)

        if slope in [-Inf, 0, Inf]
            plane[y₀:y₁, x₀:x₁] += ones(Int, (y₁ - y₀ + 1, x₁ - x₀ + 1))
        else
            # Number of rotations.
            rot = Int64(div(-slope + 1, 2))
            plane[y₀:y₁, x₀:x₁] += rotr90(Diagonal(ones(Int, x₁ - x₀ + 1)), rot)
        end
    end
end

"""Calculate the number of intersections of at least two <lines> in a ℤ
cartesian plane.  Return both the axial and the total count."""
function solve(lines :: Array{Line})
    xₘₐₓ = max([max(first.(l)...) for l in lines]...)
    yₘₐₓ = max([max(last.(l)...) for l in lines]...)

    plane = zeros(Int, (yₘₐₓ + 1, xₘₐₓ + 1))

    #= In the context of this day, I used the term “axial” as referring strictly
     = to vertical and horizontal lines only.
     =#
    axials = filter(P -> P[1][1] == P[2][1] || P[1][2] == P[2][2], lines)
    update_lines!(axials, plane)
    axial_count = count(>=(2), plane)

    diagonals = filter(P -> P[1][1] != P[2][1] && P[1][2] != P[2][2], lines)
    update_lines!(diagonals, plane)
    total_count = count(>=(2), plane)

    return (axial_count, total_count)
end

const POINTS_REX = r"(\d+),(\d+) -> (\d+),(\d+)"

function main()
    usage_and_exit(length(ARGS) != 1)

    input_data = readlines(ARGS[1])
    matched_data = match.(POINTS_REX, input_data)
    parsed_data = [parse.(Int, line.captures) for line in matched_data]
    lines = [((x₀, y₀), (x₁, y₁)) for (x₀, y₀, x₁, y₁) in parsed_data]

    S₁, S₂ = solve(lines)

    @assert S₁ == 6710
    @assert S₂ == 20121

    println(S₁)
    println(S₂)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
