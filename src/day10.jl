#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Ten, Syntax Scoring."


#= This day was considerably easy, maybe because I already worked with lexical
 = analysis before (vide Braskag).
 =#

include("Utils.jl")

using Statistics
using .Utils

const OPENER = ['(', '[', '{', '<']
const CLOSER = [')', ']', '}', '>']
const CORRUPT_ADDEND = [3, 57, 1197, 25137]

"""Calculate both the corruption score and the incompletion score of a <system>
and return them, in this order, inside a tuple."""
function solve(system :: Array{String}) :: Tuple{Int64, Int64}
    corrupt_score = 0
    incomplete_scores = Array{Int64}([])

    for line in system
        order = Array{Char}([])
        is_corrupt = false

        for sep in line
            if sep in OPENER
                push!(order, sep)
            elseif sep != CLOSER[findfirst(==(order[end]), OPENER)]
                corrupt_score += CORRUPT_ADDEND[findfirst(==(sep), CLOSER)]
                is_corrupt = true

                break
            else
                pop!(order)
            end
        end

        #= Here I assumed, based on the enunciation of the problem, that a line
         = must be either corrupt or incomplete.
         =#
        if !is_corrupt
            closers = order[end:-1:1]
            addends = [findfirst(==(sep), OPENER) for sep in closers]

            push!(incomplete_scores, reduce((a,b) -> 5*a + b, addends))
        end
    end

    return (corrupt_score, incomplete_scores |> median)
end

function main()
    usage_and_exit(length(ARGS) != 1)

    input_data = readlines(first(ARGS))

    (S₁, S₂) = input_data |> solve

    @assert S₁ == 268845
    @assert S₂ == 4038824534

    S₁ |> println
    S₂ |> println
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
