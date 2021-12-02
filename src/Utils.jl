#!/usr/bin/julia

# Copyright (C) 2021 Matheus Fernandes Bigolin <mfrdrbigolin@disroot.org>
# SPDX-License-Identifier: MIT

"General Utilities."


module Utils

export arrange, usage_and_exit

arrange(vs :: Vector, dtype = String) = [parse(dtype, v) for v in vs]

function usage_and_exit(is_exit = true)
    if is_exit
        println("Usage: ./dayN [INPUT]")

        exit(1)
    end
end

end
