#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day One, Sonar Sweep."


include("Utils.jl")

using .Utils

function solve(lst :: Vector{Int}, step_size = 1)
    let Σ = 0
        for (a, b) in zip(lst[1 : end - step_size], lst[step_size + 1 : end])
            Σ += a < b
        end

        return Σ
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    usage_and_exit(length(ARGS) != 1)

    input_data = arrange(readlines(ARGS[1]), Int)

    println(solve(input_data))
    println(solve(input_data, 3))
end
