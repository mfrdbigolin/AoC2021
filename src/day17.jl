#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"Day Seventeen, Trick Shot."


#= I am working in an analytical solution, but, for the time being, I will
 = leave the brute-force solution in part two due to time constrainsts (my
 = personal time, not the program’s).  At the very least, I put some limitations
 = on the ranges.
 =#

include("Utils.jl")

using .Utils

#= Throught this entire code the target area is assumed to be to the
 = bottom-right of the thrower.
 =#

"Find the maximum probe height possible that still lands in `target`."
function solve1(target)
    #= When the probe crosses the y = 0 line for the second time it’s velocity
     = will always be -vy - 1 (assuming vy >= 0).  Therefore, we want the
     = probe’s next step to fall exactly within the outermost vertical line of
     = the target area to maximize it’s vy.
     =#
    max_y = -target[2].start - 1

    return div(max_y^2 + max_y, 2)
end

"Calculate the x position at time `t` given the horizontal speed `vx`."
calc_x(t, vx) = if t < vx t*vx - div(t^2 - t, 2) else div(vx^2 + vx, 2) end
"Calculate the y position at time `t` given the vertical speed `vy`."
calc_y(t, vy) = t*vy - div(t^2 - t, 2)
"Calculate the position at time `t` given the speed pair `(vx, vy)`."
calc_xy(t, (vx, vy)) = (calc_x(t, vx), calc_y(t, vy))

"Count all the initial velocities that fall within the `target`."
function solve2(target)
    found_count = 0

    max_x = target[1].stop

    min_y = target[2].start
    max_y = -target[2].start - 1

    #= The speed that takes the maximum time is the one with maximum vertical
     = velocity.
     =#
    max_time = 2max_y + 2

    for vx in 1:max_x
        for vy in min_y:max_y
            for t in 1:max_time
                if all(calc_xy(t, (vx, vy)) .∈ target)
                    found_count += 1

                    break
                end
            end
        end
    end

    return found_count
end

const AREA_REX = r"target area: x=([-]?\d+)\.\.([-]?\d+), y=([-]?\d+)\.\.([-]?\d+)"

function main()
    usage_and_exit(length(ARGS) != 1)

    data = readline(first(ARGS))
    x₀, x₁, y₀, y₁ = parse.(Int, match(AREA_REX, data).captures)
    target = [x₀:x₁, y₀:y₁]

    println(solve1(target))
    println(solve2(target))
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
