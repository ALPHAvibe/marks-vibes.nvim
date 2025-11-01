local M = {}

function M.open_float_at_mark(mark)
  -- Get mark position - for global marks we need getpos
  local mark_info = vim.fn.getpos("'" .. mark)
  local bufnr = mark_info[1]
  local line = mark_info[2]
  local col = mark_info[3] - 1 -- Convert to 0-indexed

  if line == 0 then
    vim.notify("Mark '" .. mark .. "' not set", vim.log.levels.WARN)
    return
  end

  -- For global marks (A-Z), bufnr will be set
  -- For local marks (a-z), bufnr will be 0 (current buffer)
  local src_buf = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr

  -- Check if buffer is valid
  if not vim.api.nvim_buf_is_valid(src_buf) then
    vim.notify("Buffer for mark '" .. mark .. "' is not valid", vim.log.levels.ERROR)
    return
  end

  -- Load the buffer if it's not loaded
  if not vim.api.nvim_buf_is_loaded(src_buf) then
    vim.fn.bufload(src_buf)
  end

  -- Get ALL lines from the buffer
  local lines = vim.api.nvim_buf_get_lines(src_buf, 0, -1, false)

  -- Get filename for the title
  local filename = vim.api.nvim_buf_get_name(src_buf)
  filename = vim.fn.fnamemodify(filename, ':t') -- Just the filename, not full path

  -- Create a buffer for the floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  -- Copy filetype for syntax highlighting
  local ft = vim.api.nvim_buf_get_option(src_buf, 'filetype')
  vim.api.nvim_buf_set_option(buf, 'filetype', ft)

  -- Calculate window size - Telescope style (90% of screen)
  local width = math.floor(vim.o.columns * 0.7)
  local height = math.floor(vim.o.lines * 0.9)

  local win_config = {
    relative = 'editor',
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    title = string.format(" %s - Mark '%s' - Line %d ", filename, mark, line),
    title_pos = 'center',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  -- Enable line numbers
  vim.api.nvim_win_set_option(win, 'number', true)
  vim.api.nvim_win_set_option(win, 'relativenumber', false)

  -- Position cursor at the marked line
  vim.api.nvim_win_set_cursor(win, { line, col })

  -- Center the marked line in the window
  vim.cmd('normal! zz')

  -- Highlight the marked line
  local ns_id = vim.api.nvim_create_namespace('telescope_marks_vibes_highlight')
  vim.api.nvim_buf_add_highlight(buf, ns_id, 'CursorLine', line - 1, 0, -1)

  -- Set up keymaps for the floating window
  local opts = { buffer = buf, nowait = true }
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true)
  end, opts)
  vim.keymap.set('n', '<Esc>', function()
    vim.api.nvim_win_close(win, true)
  end, opts)

  -- Allow jumping to the mark location in the actual buffer
  vim.keymap.set('n', '<CR>', function()
    vim.api.nvim_win_close(win, true)
    -- Switch to the correct buffer first
    vim.api.nvim_set_current_buf(src_buf)
    vim.api.nvim_win_set_cursor(0, { line, col })
  end, opts)
end

return M
