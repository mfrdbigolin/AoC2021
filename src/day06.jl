#!/usr/bin/julia

# Copyright (C) 2021, 2022 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Six, Lanternfish."


include("Utils.jl")

using DelimitedFiles
using .Utils

"Calculate the number of fishes after `days` given a `fishpop`."
function solve(fishpop :: Array{Int}, days :: Int64)
    ages = zeros(Int, 9)

    for fish in fishpop
        ages[fish + 1] += 1
    end

    for i in 1:days
        # This cycles modularly through the ages.
        (start, final) = (mod1(i, 9), mod1(i + 7, 9))

        ages[final] += ages[start]
    end

    return sum(ages)
end

function main()
    usage_and_exit(length(ARGS) != 1)

    data = readdlm(first(ARGS), ',', Int)

    println(solve(data, 80))
    println(solve(data, 256))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
