<<<<<<< HEAD
if vim.loader then
	vim.loader.enable()
end

_G.dd = function(...)
	require("util.debug").dump(...)
end
vim.print = _G.dd

require("config.lazy")
=======
vim.api.nvim_echo({
  {
    "Do not use this repository directly\n",
    "ErrorMsg",
  },
  {
    "Please check the docs on how to get started with LazyVim\n",
    "WarningMsg",
  },
  { "Press any key to exit", "MoreMsg" },
}, true, {})

vim.fn.getchar()
vim.cmd([[quit]])
>>>>>>> upstream/main
