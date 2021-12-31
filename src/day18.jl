#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Eighteen, Snailfish."


#= This day really took me some time, I had to rewrite the code twice, because
 = I was unatentive to one of the conditions of the problem (the order of the
 = operations).  Alas, Julia’s typesystem didn’t helped me that much either.
 =#

include("Utils.jl")

using .Utils

"Calculate the magnitude of the `snailnum`."
function calc_magn(snailnum :: Vector{Complex{Int}})
    magn = 0
    depth = 0
    factors = Array{Int}([])

    for lex in snailnum[1:end - 1]
        if isreal(lex)
            magn += Int(lex)*prod(factors[1:depth])
            factors[depth] = if factors[depth] == 3 2 else 3 end
        end

        depth += imag(lex)

        if depth > length(factors)
            push!(factors, 3)
        elseif imag(lex) == -1
            factors[depth] = if factors[depth] == 3 2 else 3 end
        end
    end

    return magn
end

"""Explode a pair in `snailnum`, when applicable, return whether the vector was
mutated."""
function explode!(snailnum :: Vector{Complex{Int}})
    depth = 0

    i = 0
    while (i += 1) <= length(snailnum)
        lex = snailnum[i]

        if lex == im && depth >= 4
            (a, b) = snailnum[i + 1], snailnum[i + 2]

            j = i - 1
            while j >= 1
                if isreal(snailnum[j])
                    snailnum[j] += a
                    break
                end

                j -= 1
            end

            j = i + 4
            while j <= length(snailnum)
                if isreal(snailnum[j])
                    snailnum[j] += b
                    break
                end

                j += 1
            end

            splice!(snailnum, i:i + 3, 0)

            return true
        end

        depth += imag(lex)
    end

    return false
end

"""Split a number in `snailnum`, when applicable, return whether the vector was
mutated."""
function split!(snailnum :: Vector{Complex{Int}})
    i = 0
    while (i += 1) <= length(snailnum)
        lex = snailnum[i]

        if isreal(lex) && Int(lex) >= 10
            (m, r) = divrem(Int(lex), 2)
            splice!(snailnum, i, [im, m, m + r, -im])

            return true
        end
    end

    return false
end

"Reduce the `snailnum` (mutating!), return whether the vector was changed."
reduce!(snailnum :: Vector{Complex{Int}}) = explode!(snailnum) || split!(snailnum)

"Sum and reduce all `snailnums`, in order, and return the final magnitude."
function solve1(snailnums :: Vector{Vector{Complex{Int}}})
    res = first(snailnums)

    for addend in snailnums[2:end]
        res = vcat(im, res, addend, -im)

        while reduce!(res) end
    end

    return calc_magn(res)
end

"Find the maximum magnitude of any sum of two distinct `snailnums` in the set."
function solve2(snailnums :: Vector{Vector{Complex{Int}}})
    max_magn = 0

    for i in eachindex(snailnums)
        for j in eachindex(snailnums)
            if i == j
                continue
            end

            addition = solve1([snailnums[i], snailnums[j]])

            max_magn = max(max_magn, addition)
        end
    end

    return max_magn
end

"Parse `snailnum` string into a numerical format."
function parsenum(snailnum :: String)
    parsed = Array{Complex{Int}}([])

    i = 0
    while (i += 1) <= length(snailnum)
        lex = snailnum[i]

        #= Use the imaginary unit for the pair opening, and its additive
         = inverse for the closing.
         =#
        if lex == '['
            push!(parsed, im)
        elseif lex == ']'
            push!(parsed, -im)
        elseif isnumeric(lex)
            numstr = Array{Char}([lex])

            while isnumeric(snailnum[i + 1])
                push!(numstr, snailnum[i += 1])
            end

            push!(parsed, array2num(parse.(Int, numstr)))
        end
    end

    return parsed
end

function main()
    usage_and_exit(length(ARGS) != 1)

    data = readlines(first(ARGS))
    real_data = parsenum.(data)

    println(solve1(real_data))
    println(solve2(real_data))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
