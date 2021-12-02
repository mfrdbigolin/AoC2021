#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Two, Dive!"


include("Utils.jl")

using .Utils

const DIRS = Dict("forward" => 1, "down" => im, "up" => -im)

function solve(commands, is_aiming = false)
    coords = [DIRS[dir]*magn for (dir, magn) in commands]

    let pos = aim = 0
        for coord in coords
            if is_aiming
                aim += imag(coord)
                pos += real(coord) + real(coord)*aim*im
            else
                pos += coord
            end
        end

        return real(pos) * imag(pos)
    end
end

const INSTR_REG = r"(forward|down|up) (\d+)"

if abspath(PROGRAM_FILE) == @__FILE__
    usage_and_exit(length(ARGS) != 1)

    input_data = [match(INSTR_REG, dir).captures for dir in readlines(ARGS[1])]
    typed_data = [[dir, parse(Int, magn)] for (dir, magn) in input_data]

    println(solve(typed_data))
    println(solve(typed_data, true))
end
