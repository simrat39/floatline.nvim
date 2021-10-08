vim.cmd([[set packpath=/tmp/nvim/site]])
vim.cmd([[set rtp +=./]])

vim.cmd([[packadd nvim-web-devicons]])

local status_name = os.getenv('STATUS_NAME')
local benchmark_num = os.getenv('BENCHMARK_NUM')

benchmark_num = benchmark_num and tonumber(benchmark_num) or 10000

local ffi = require('ffi_convert')
vim.opt.termguicolors = true

local function benchmark(num, f, ...)
    local start_time = vim.loop.hrtime()
    for _ = 1, num do
        f(...)
    end
    return (vim.loop.hrtime() - start_time) / 1E9
end

local function log(msg)
    vim.api.nvim_out_write(msg .. '\n')
    local fp = assert(io.open('./output.txt', 'a'))
    local str = string.format('%s\n', msg)
    fp:write(str)
    fp:close()
end

local check = pcall(require, 'specs.' .. status_name)
if not check then
    log("Error Can't load statusline :" .. status_name)
    return
end

vim.cmd([[e lua/benchmark.lua]])

vim.defer_fn(function()
    local winid = vim.api.nvim_get_current_win()
    local ok, status_opt = pcall(vim.api.nvim_win_get_option, winid, 'statusline')

    local statusline_text = ''
    if not ok then
        status_opt = vim.o.statusline
    end
    local time = benchmark(benchmark_num, function()
        statusline_text = ffi.get_stl_format(status_opt)
    end)
    log('')
    log(string.format('Time %s: %s', status_name, time))
    log('Text:')
    log(statusline_text)
    log('')
    vim.cmd('quit')
end, 300)
