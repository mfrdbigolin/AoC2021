#!/usr/bin/julia

# Copyright (C) 2021, 2022 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Thirteen, Transparent Origami."


# This certainly was a enjoying day, especially part II.

include("Utils.jl")

using .Utils

"Fold the `dots` according to the `folds`’ instructions."
function fold_dots(dots :: Set{Tuple{Int64, Int64}}, folds :: Array{Tuple{Char, Int64}}) :: Set{Tuple{Int64, Int64}}
    folded_dots = Set{Tuple{Int, Int}}(copy(dots))

    for (axis, pos) in folds
        for (x, y) in folded_dots
            if axis == 'x' && x > pos
                push!(folded_dots, (2*pos - x, y))
                delete!(folded_dots, (x,y))
            elseif axis == 'y' && y > pos
                push!(folded_dots, (x, 2*pos - y))
                delete!(folded_dots, (x,y))
            end
        end
    end

    return folded_dots
end

"Calculate the number of `dots` after one `fold`."
function solve1(dots :: Set{Tuple{Int64, Int64}}, fold :: Tuple{Char, Int64}) :: Int64
    folded_dots = fold_dots(dots, [fold])

    return length(folded_dots)
end

"Apply the `folds` to the `dots` and print the secret code."
function solve2(dots :: Set{Tuple{Int64, Int64}}, folds :: Array{Tuple{Char, Int64}})
    folded_dots = fold_dots(dots, folds)

    max_x, max_y = maximum(first.(folded_dots)), maximum(last.(folded_dots))

    for i in 0:max_y
        for j in 0:max_x
            if (j,i) in folded_dots
                print('█')
            else
                print('⋅')
            end
        end

        println()
    end
end

const DOTS_REX = r"(\d+),(\d+)"
const FOLDS_REX = r"fold along (\w)=(\d+)"

function main()
    usage_and_exit(length(ARGS) != 1)

    input_data = readlines(first(ARGS))

    dots_data = filter(line -> !startswith(line, "fold along") && line != "", input_data)
    folds_data = filter(line -> startswith(line, "fold along"), input_data)

    dots_untyped = [match(DOTS_REX, dot).captures for dot in dots_data]
    dots = Set([Tuple(parse.(Int, dot)) for dot in dots_untyped])

    folds_untyped = [match(FOLDS_REX, fold).captures for fold in folds_data]
    folds = [(collect(axis)[1], parse(Int, pos)) for (axis, pos) in folds_untyped]

    println(solve1(dots, folds[1]))
    solve2(dots, folds)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
