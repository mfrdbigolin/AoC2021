#!/usr/bin/julia

# Copyright (C) 2022 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Twenty-Five, Sea Cucumber."


include("Utils.jl")

using .Utils

"Find the first step in which no sea `cucumbers` move."
function solve(cucumbers :: Matrix{Complex{Int}})
    old = copy(cucumbers)
    new = copy(cucumbers)

    sz = size(cucumbers)

    step = 0
    changed = true
    while changed
        step += 1
        changed = false

        for dir in [(1, 0), (0, 1)]
            for ind in CartesianIndices(new)
                if old[ind] != complex(dir...)
                    continue
                end

                moveto = CartesianIndex(@. mod1((ind.I + dir), sz))

                if old[moveto] == 0
                    new[ind] = 0
                    new[moveto] = complex(dir...)
                    changed = true
                end
            end

            old = copy(new)
        end
    end

    return step
end

function main()
    usage_and_exit(length(ARGS) != 1)

    data = readlines(first(ARGS))
    numdata = [[[0, 1, im][findfirst(s, ".>v")] for s in r] for r in data]
    matdata = hcat(numdata...)

    println(solve(matdata))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
