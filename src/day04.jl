#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Four, Giant Squid."


include("Utils.jl")

using DelimitedFiles
using .Utils

"""Provided a <deck> and a set of <boards>, return all the winners from the
first to the last."""
function solve(deck :: Array{Int64}, boards :: Array{Array{Int64, 2}})
    winners = []
    # Remaining rows and columns not yet fully filled.
    remaining = fill(fill(5, 10), size(boards, 1))
    # Boards not yet victorious.
    active = fill(true, size(boards, 1))

    for (i, card) in enumerate(deck)
        if length(boards[active]) == 0
            break
        end

        found = findall.(==(card), boards[active])

        # Calculate the ocurrence of the card in all rows and columns.
        rows = [[-length(filter(a -> first(a.I) == j, p)) for j in 1:5] for p in found]
        cols = [[-length(filter(a -> last(a.I) == j, p)) for j in 1:5] for p in found]

        remaining[active] += vcat.(rows, cols)

        nil = in.(0, remaining[active])
        if any(nil)
            chosen = (1:size(boards, 1))[active][nil]
            # Deactivate winning boards.
            active[chosen] = fill(false, length(chosen))
            unmarked = filter(!in(deck[1:i]), boards[chosen][1])
            winners = vcat(winners, sum(unmarked)*card)
        end
    end

    return winners
end

function main()
    usage_and_exit(length(ARGS) != 1)

    decks_data = readline(first(ARGS))
    boards_data = readdlm(first(ARGS), Int, skipstart = 2)

    deck = parse.(Int, split(decks_data, ","))

    boards_number = div(size(boards_data, 1), size(boards_data, 2))
    boards = [boards_data[5i - 4 : 5i, 1:5] for i in 1:boards_number]

    winners = solve(deck, boards)

    @assert first(winners) == 54275
    @assert last(winners) == 13158

    println(first(winners))
    println(last(winners))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
