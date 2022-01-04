#!/usr/bin/julia

# Copyright (C) 2022 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Twenty-One, Dirac Dice."


include("Utils.jl")

using .Utils

"All the possible rolls of the deterministic die."
const DET_DIE = @. mod((10:-1:1) - 4, 10)

"""Using the deterministic dice and provided the position, `(P₁, P₂)`, return
the product of the losing player’s score with the number of dice rolls."""
function solve1((P₁, P₂))
    S₁ = S₂ = 0
    rolled = 0

    while S₁ < 1000 && S₂ < 1000
        for i in eachindex(DET_DIE)
            if S₁ >= 1000 || S₂ >= 1000
                break
            end

            rolled += 1

            if !iseven(i)
                P₁ += DET_DIE[i]
                S₁ += mod1(P₁, 10)
            else
                P₂ += DET_DIE[i]
                S₂ += mod1(P₂, 10)
            end
        end
    end

    return min(S₁, S₂)*3rolled
end

"The distribution of the rolls of a dirac die in a single round."
const DIRAC_DIE = [3 => 1, 4 => 3, 5 => 6, 6 => 7, 7 => 6, 8 => 3, 9 => 1]

"Storage of game states."
GMS = Dict{Tuple{Tuple{Int, Int}, Tuple{Int, Int}}, Tuple{Int, Int}}()

"""Using the dirac dice and given the initial position, `(P₁, P₂)`, return the
number of victories of each player."""
function solve2((P₁, P₂), (S₁, S₂) = (0, 0))
    key = ((P₁, P₂), (S₁, S₂))

    if S₁ >= 21
        return (1, 0)
    elseif S₂ >= 21
        return (0, 1)
    elseif haskey(GMS, key)
        return GMS[key]
    end

    vic = (0, 0)

    for (roll, n) in DIRAC_DIE
        P_new = mod1(P₁ + roll, 10)
        S_new = S₁ + P_new

        v₂, v₁ = solve2((P₂, P_new), (S₂, S_new)) .* n
        vic = vic .+ (v₁, v₂)
    end

    GMS[key] = vic
    return vic
end

const PLAYER_REX = r"Player \d starting position: (\d+)"

function main()
    usage_and_exit(length(ARGS) != 1)

    data = readlines(first(ARGS))
    players = [parse(Int, pl.captures[1]) for pl in match.(PLAYER_REX, data)]

    println(solve1(players))
    println(first(solve2(players)))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
