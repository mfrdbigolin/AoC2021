#!/usr/bin/julia

# Copyright (C) 2021, 2022 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Seven, The Treachery of Whales."


include("Utils.jl")

using DelimitedFiles
using Statistics
using .Utils

"Calculate the minimum amount of fuel used to align the `crabs`’ position."
function solve1(crabs :: Array{Int64}) :: Int64
    median_crab = crabs |> median |> floor

    return crabs .- median_crab .|> abs |> sum
end

#= Initially I only used the floor function and it worked properly, but as an
 = user in Reddit pointed out, floor() isn’t always the right rounding.
 =#

"""Calculate the minimum amount of fuel used to align the `crabs`’ position,
with an arithmetic series usage of fuel."""
function solve2(crabs :: Array{Int64}) :: Int64
    mean_crab = crabs |> mean |> floor |> Int64

    Σ₁ = crabs .- mean_crab .|> abs .|> ∑
    Σ₂ = crabs .- (mean_crab + 1) .|> abs .|> ∑

    return [Σ₁, Σ₂] .|> sum |> minimum
end

function main()
    usage_and_exit(length(ARGS) != 1)

    input_data = readdlm(first(ARGS), ',', Int)

    S₁, S₂ = input_data |> solve1, input_data |> solve2

    @assert S₁ == 343441
    @assert S₂ == 98925151

    S₁ |> println
    S₂ |> println
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
