vim.api.nvim_create_autocmd("SessionLoadPost", {
  group = vim.api.nvim_create_augroup("LazyVimSession", { clear = true }),
  callback = function()
    vim.cmd("colorscheme catppuccin")
    vim.cmd("redraw!")

    vim.defer_fn(function()
      local bufs = vim.api.nvim_list_bufs()
      for _, bufnr in ipairs(bufs) do
        if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("doautocmd BufRead")
          end)
        end
      end
    end, 100)
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})
