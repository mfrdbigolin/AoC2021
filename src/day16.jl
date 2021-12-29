#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Sixteen, Packet Decoder."


#= This was a really fun day to write. Initially glossed over this day, because
 = I went to the movies.
 =#

include("Utils.jl")

using .Utils

"Operators used by the packet system."
const OPERATORS = [+, *, min, max, missing, Int ∘ >, Int ∘ <, Int ∘ ==]

"Process a `packet` and return its version sum, total value and stop point."
function process_packet(packet :: Array{Int8})
    ptype = bin2dec(packet[4:6])
    plength = 1
    step = 7

    if ptype != 4
        length_type = Bool(packet[7])
        length_bits = if length_type 11 else 15 end

        plength = bin2dec(packet[8:7 + length_bits])

        step += 1 + length_bits
    end

    version_sum = bin2dec(packet[1:3])
    number = 0
    operands = Array{Int}([])

    is_final_group = false

    while !is_final_group && plength > 0
        if ptype == 4
            is_final_group = !Bool(packet[step])
            number = 16number + bin2dec(packet[step + 1:step + 4])

            step += 5
        else
            (version, op, j) = process_packet(packet[step:end])

            push!(operands, op)
            version_sum += version

            plength -= if length_type 1 else j end

            step += j
        end
    end

    if ptype != 4
        number = OPERATORS[ptype + 1](operands...)
    end

    return (version_sum, number, step - 1)
end

"Hexadecimal to four-bit (nibble) binary table."
const HEX = Dict(['0' => "0000", '1' => "0001", '2' => "0010", '3' => "0011",
                  '4' => "0100", '5' => "0101", '6' => "0110", '7' => "0111",
                  '8' => "1000", '9' => "1001", 'A' => "1010", 'B' => "1011",
                  'C' => "1100", 'D' => "1101", 'E' => "1110", 'F' => "1111"])

"Find the version sum and the final value of the `packet`."
function solve(packet :: String)
    bits = Array{Int8}([])

    for hex in collect(packet)
        push!(bits, parse.(Int8, collect(HEX[hex]))...)
    end

    return process_packet(bits)[1:2]
end

function main()
    usage_and_exit(length(ARGS) != 1)

    data = readline(first(ARGS))

    S₁, S₂ = solve(data)

    println(S₁)
    println(S₂)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
