#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Three, Binary Diagnostic."


include("Utils.jl")

using .Utils

calculate_rate(nums, op, i = 1) = op(sum(nums[:,i]), size(nums, 1)//2)

function calculate_rating(nums, op, i = 1)
    mat_size = size(nums, 1)

    if mat_size == 1
        return nums[1,:]
    end

    rate = calculate_rate(nums, op, i)
    triaged_nums = nums[nums[:,i] .== rate,:]
    return calculate_rating(triaged_nums, op, i + 1)
end

function solve1(nums)
    k = size(nums, 2)

    ϵ = [calculate_rate(nums, <, i) for i in 1:k] |> bin2dec
    γ = 2^k - 1 - ϵ

    return ϵ*γ
end

function solve2(nums)
    O₂ = calculate_rating(nums, >=) |> bin2dec
    CO₂ = calculate_rating(nums, <) |> bin2dec

    return O₂ * CO₂
end

function main()
    usage_and_exit(length(ARGS) != 1)

    input_data = readlines(ARGS[1])
    matrix_data = parse.(Int, hcat(collect.(input_data)...))'

    @assert solve1(matrix_data) == 3985686
    @assert solve2(matrix_data) == 2555739

    println(solve1(matrix_data))
    println(solve2(matrix_data))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
