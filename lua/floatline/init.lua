local api = vim.api
local namespace = api.nvim_create_namespace('floatline.floatline_status')

local M = _G.FloatLine or {
    state = {},
}
_G.FloatLine = M

local default_config = {
    interval = 300,
    blend = 0,
    status = nil,
}
local state = M.state
local close_float_win = function()
    if
        state.floatline
        and state.floatline.winid
        and api.nvim_win_is_valid(state.floatline.winid)
    then
        api.nvim_buf_clear_namespace(state.floatline.bufnr, namespace, 1, 2)
        api.nvim_win_close(state.floatline.winid, true)
        state.floatline.winid = nil
        state.floatline.bufnr = nil
    end
end

local create_floating_win = function()
    local cur_winid = api.nvim_get_current_win()
    close_float_win()
    local status_bufnr = api.nvim_create_buf(false, true)
    local content_opts = {
        relative = 'editor',
        width = vim.o.columns,
        height = 1,
        col = 0,
        row = vim.o.lines - vim.o.cmdheight - 1,
        focusable = false,
        style = 'minimal',
    }
    local status_winid = api.nvim_open_win(status_bufnr, true, content_opts)
    api.nvim_buf_set_option(status_bufnr, 'ft', 'floatline')
    api.nvim_buf_set_option(status_bufnr, 'buftype', 'nofile')
    api.nvim_win_set_option(status_winid, 'wrap', false)
    api.nvim_win_set_option(status_winid, 'number', false)
    api.nvim_win_set_option(status_winid, 'relativenumber', false)
    api.nvim_win_set_option(status_winid, 'winblend', M.config.blend)
    api.nvim_win_set_option(status_winid, 'cursorline', false)
    api.nvim_win_set_option(status_winid, 'signcolumn', 'no')
    api.nvim_win_set_option(status_winid, 'winhighlight', 'Search:None')
    state.floatline.winid = status_winid
    state.floatline.bufnr = status_bufnr
    api.nvim_win_set_cursor(status_winid, { 1, 1 })
    api.nvim_set_current_win(cur_winid)
end

local function check_tab_have_floatline_window()
    local tabnr = api.nvim_get_current_tabpage()
    local windows = vim.api.nvim_tabpage_list_wins(tabnr)
    local count = 0
    for _, winid in pairs(windows) do
        if api.nvim_win_get_config(winid).relative == '' then
            count = count + 1
        end
    end
    return count == 1
end

M.floatline_fix_command = function(cmd)
    cmd = cmd or 'quit'
    if check_tab_have_floatline_window() then
        close_float_win()
    end
    vim.cmd(cmd)
end

M.floatline_on_tabenter = function()
    close_float_win()
    create_floating_win()
end

local function get_layout_height(tree_layout, height)
    if tree_layout[1] == 'row' then
        --if it is row we only get the first window
        return get_layout_height(tree_layout[2][1], height)
    elseif tree_layout[1] == 'col' then
        --need to sum all window layout
        for _, value in pairs(tree_layout[2]) do
            -- +1 because the size for statusline
            height = get_layout_height(value, height + 1)
        end
        return height - 1
    elseif tree_layout[1] == 'leaf' then
        -- get window height
        if api.nvim_win_is_valid(tree_layout[2]) then
            return api.nvim_win_get_height(tree_layout[2]) + height
        end
        return height
    end
end

M.floatline_on_resize = function()
    if api.nvim_win_is_valid(state.floatline.winid) then
        local layout = vim.fn.winlayout(api.nvim_get_current_tabpage())
        local tabline = vim.o.showtabline > 0 and 1 or 0
        if vim.o.showtabline == 1 then
            tabline = #vim.api.nvim_list_tabpages() > 1 and 1 or 0
        end
        local height = get_layout_height(layout, tabline)
            or vim.o.lines - vim.o.cmdheight - 1
        api.nvim_win_set_config(state.floatline.winid, {
            relative = 'editor',
            width = vim.o.columns,
            height = 1,
            col = 0,
            row = height,
            focusable = false,
            style = 'minimal',
        })
    end
end

local function get_status(winid)
    if M.config.status then
        local st = M.config.status(winid)
        if st then return st end
    end
    local ok, status_opt = pcall(api.nvim_win_get_option, winid, 'statusline')
    if not ok then
        status_opt = vim.o.statusline
    end
    return status_opt
end

M.update_status = function()
    if
        not state.floatline.bufnr or not api.nvim_win_is_valid(state.floatline.winid)
    then
        create_floating_win()
        return
    end
    local bufnr = api.nvim_get_current_buf()
    local winid = api.nvim_get_current_win()
    if not api.nvim_win_is_valid(winid) then
        return
    end
    local status = get_status(winid)
    local status_data = api.nvim_eval_statusline(status, {
        winid = winid,
        maxwidth = vim.o.columns,
        highlights = true,
        use_tabline = false,
    })
    state.last_bufnr = bufnr
    state.last_winid = winid
    vim.api.nvim_buf_set_lines(
        state.floatline.bufnr,
        0,
        1,
        false,
        { status_data.str }
    )
    state.text_groups = {}
    local previous_group = {}
    local str_length = #status_data.str
    if status_data.highlights then
        for _, hl in pairs(status_data.highlights) do
            if hl.start then
                if previous_group.range then
                    previous_group.range[2] = hl.start
                end
                previous_group = {
                    hl = hl.group,
                    range = { hl.start, str_length},
                }
                table.insert(state.text_groups, previous_group)
            end
        end
    end
end

M.setup = function(opts)
    opts = opts or {}
    api.nvim_exec(
        [[augroup FloatLine
            au!
            au TabEnter * lua require("floatline").floatline_on_tabenter()
            au VimResized * lua require("floatline").floatline_on_resize()
        augroup END]],
        false
    )
    -- remove this when this issue is fixed
    -- https://github.com/neovim/neovim/issues/11440
    api.nvim_exec(
        'command! -nargs=* Wquit lua require("floatline").floatline_fix_command("quit")',
        false
    )
    api.nvim_exec(
        'command! -nargs=* Wbdelete lua require("floatline").floatline_fix_command("bdelete")',
        false
    )
    vim.g.wl_quit_command = 'Wquit'
    vim.g.wl_delete_command = 'Wbdelete'

    M.config = vim.tbl_extend('force', default_config, opts)
    state.floatline = {}
    state.text_groups = {}

    if not FloatLine.floatline_set_decoration then
        -- only set it one time
        vim.api.nvim_set_decoration_provider(namespace, {
            on_start = function()
                return state.floatline ~= nil
            end,
            on_win = function(_, winid)
                return state.floatline and winid == state.floatline.winid
            end,
            on_line = function(_, winid, bufnr, row)
                if row == 0 and winid == state.floatline.winid then
                    for _, group in pairs(state.text_groups) do
                        if group.range and group.hl ~= '' then
                            vim.api.nvim_buf_set_extmark(
                                bufnr,
                                namespace,
                                0,
                                group.range[1],
                                {
                                    end_line = 0,
                                    end_col = group.range[2],
                                    hl_group = group.hl,
                                    hl_mode = 'combine',
                                    ephemeral = true,
                                }
                            )
                        end
                    end
                end
            end,
        })
        FloatLine.floatline_set_decoration = true
    end
    create_floating_win()
    M.start_runner()
end

M.start_runner = function()
    M.stop_runner()
    local timer = vim.loop.new_timer()
    timer:start(
        200,
        M.config.interval,
        vim.schedule_wrap(function()
            M.update_status()
        end)
    )
    state.timer = timer
end

M.stop_runner = function()
    if state.timer then
        state.timer:stop()
        state.timer = nil
    end
end

return M
