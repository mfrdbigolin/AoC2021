#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Fourteen, Extended Polymerization."


include("Utils.jl")

# N.b.: external package, used for the Accumulator data structure.
using DataStructures

using .Utils

"""Return the difference between the most common element with the least common
element after `steps`, according to `rules` and starting with `template`."""
function solve(template :: Array{Char}, rules :: Dict{String, Char}, steps :: Int)
    # Group the template letters in adjacent pairs.
    pairs = join.(zip(collect(template[1:end-1]), collect(template[2:end])))

    space = counter(pairs)
    letters = counter(template)

    for _ in 1:steps
        new_space = Accumulator{String, Int}()

        for (k, v) in space
            letters[rules[k]] += v

            new_space[join([first(k), rules[k]])] += v
            new_space[join([rules[k], last(k)])] += v
            new_space[k] -= v
        end

        merge!(+, space, new_space)
    end

    return abs(reduce(-, extrema(values(letters))))
end

const RULES_REX = r"(\w{2}) -> (\w)"

function main()
    usage_and_exit(length(ARGS) != 1)

    data = readlines(first(ARGS))

    template = collect(data[1])

    rules_data = data[3:end]
    rules_array = [Tuple(m.captures) for m in match.(RULES_REX, rules_data)]
    rules = Dict{String, Char}([(p, first(r)) for (p, r) in rules_array])

    println(solve(template, rules, 10))
    println(solve(template, rules, 40))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
