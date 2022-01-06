#!/usr/bin/julia

# Copyright (C) 2021, 2022 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Eight, Seven Segment Search."


#= This day involved some heavy logical deductions, so I attempted to provide
 = explananations in the program. Thus, I hope the reasoning I outlined
 = throught this code is clear to the reader.
 =#

include("Utils.jl")

using .Utils

"Count how many times the digits 1, 4, 7, or 8 appear in the `output` values."
solve1(output) = count.(d -> length(d) in [2,4,3,7], output) |> sum

"Segments used by each digit."
const DIGITS = ([
    [1,2,3,5,6,7], [3,6], [1,3,4,5,7], [1,3,4,6,7], [2,3,4,6],
    [1,2,4,6,7], [1,2,4:7...], [1,3,6], [1:7...], [1:4...,6,7]
])

"Decode the wires mapping in the `pattern` and return the configuration."
function decode_wires(pattern)
    conf = zeros(Int, 7)

    let_count = [sum(count.(in(letter), pattern)) for letter in 'a':'g']
    pat_length = length.(pattern)

    # Find the signal wires which have unique length.
    conf[2], conf[5], conf[6] = [findfirst(==(i), let_count) for i in [6,4,9]]

    # Segments which are useful for decoding the signal wires.
    one = Set(collect(pattern[findfirst(==(2), pat_length)]))
    seven = Set(collect(pattern[findfirst(==(3), pat_length)]))
    four = collect(pattern[findfirst(==(4), pat_length)]) .- ('a' - 1)

    # Which signal wire is in seven but not in one.
    conf[1] = first(setdiff(seven, one)) - 'a' + 1
    # The signal wire with length eight besides the top one.
    conf[3] = filter(!in(conf), findall(==(8), let_count))[1]
    # Signal wire in four not yet found.
    conf[4] = first(filter(!in(conf), four))
    # Find the only signal wire not yet marked.
    conf[7] = 28 - sum(conf)

    return conf
end

"Sum all the output values, given the `patterns` and the `digits`."
function solve2(patterns, digits)
    sum_output = 0

    for (i, pat) in enumerate(patterns)
        conf = decode_wires(pat)

        output = zeros(Int, 4)

        for (j, letter_digit) in enumerate(digits[i])
            digit = collect(letter_digit) .- ('a' - 1)
            conf_digit = sort([findfirst(==(d), conf) for d in digit])
            output[j] = findfirst(==(conf_digit), DIGITS) - 1
        end

        sum_output += array2num(output)
    end

    return sum_output
end

function main()
    usage_and_exit(length(ARGS) != 1)

    data = readlines(first(ARGS))

    entries = @. filter(!=("|"), split(data, " "))

    patterns = [getindex(entry, 1:10) for entry in entries]
    digits = [getindex(entry, 11:length(entries[1])) for entry in entries]

    println(solve1(digits))
    println(solve2(patterns, digits))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
