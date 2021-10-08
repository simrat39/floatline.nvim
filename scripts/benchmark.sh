#! /bin/bash

export BENCHMARK_NUM=$1

function benchmark {
    export STATUS_NAME=$1
    nvim --headless -u lua/benchmark.lua 
}

benchmark airline
benchmark lightline
benchmark galaxyline
benchmark windline
benchmark lualine
benchmark feline


