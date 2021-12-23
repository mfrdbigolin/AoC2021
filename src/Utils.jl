#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"General Utilities."


module Utils

export arrange, usage_and_exit, bin2dec, ∑, array2num

arrange(vs :: Vector, dtype = String) = [parse(dtype, v) for v in vs]

function usage_and_exit(is_exit = true)
    if is_exit
        println("Usage: ./dayN [INPUT]")

        exit(1)
    end
end

bin2dec(B :: AbstractArray) = sum((*).(B, (^).(2, (length(B) - 1):-1:0)))

"Summation of all integer numbers between [0, n]."
∑(n :: Int64) = (n^2 + n)/2

"Transform an array <N> of digits in a number."
array2num(N :: AbstractArray) = N .* (^).(10, (length(N) - 1):-1:0) |> sum

end
