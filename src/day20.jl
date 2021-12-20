#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Twenty, Trench Map."


include("Utils.jl")

using .Utils

"""Apply the <pattern> filter to the <image> <steps> times, return the number
of lit pixels in the final image."""
function solve(pattern :: BitArray, image :: BitArray{2}, steps :: Int) :: Int
    old_size = size(image)
    new_size = old_size .+ 4steps

    new_image = zeros(Bool, new_size)
    # Insert the old image in the new pixel grid.
    new_image[(1:old_size[1]) .+ 2steps, (1:old_size[2]) .+ 2steps] = image

    for step in 1:steps
        tmp_image = similar(new_image)

        inds = CartesianIndices(new_image)
        start, final = first(inds), last(inds)

        @views for i in inds
            start_row, start_col = max(start, i - CartesianIndex(1,1)).I
            final_row, final_col = min(final, i + CartesianIndex(1,1)).I

            neighbors = new_image[start_row:final_row, start_col:final_col]
            bit = bin2dec(vcat(eachrow(neighbors)...)) + 1

            tmp_image[i] = pattern[bit]
        end

        #= “Clean” the borders from generated “artifacts” due to the infinite
         = size of the grid, do this in even turns for optimality.
         =#
        if iseven(step)
            @. (tmp_image[:,1] = tmp_image[1,:]
              = tmp_image[:,end] = tmp_image[end,:] = 0)
        end

        new_image = copy(tmp_image)
    end

    return count(new_image)
end

function main()
    usage_and_exit(length(ARGS) != 1)

    data = readlines(first(ARGS))

    pattern = BitArray(collect(data[1]) .== '#')
    image = BitArray{2}(hcat([i .== '#' for i in collect.(data[3:end])]...)')

    println(solve(pattern, image, 2))
    println(solve(pattern, image, 50))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
