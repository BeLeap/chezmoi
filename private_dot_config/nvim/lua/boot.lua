vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  dev = {
    path = "~/projects",
  },
  diff = {
    cmd = "diffview.nvim",
  },
  defaults = {
    lazy = true,
  },
  install = {
    colorscheme = { "onedark" },
  },
})

require("keymap")
require("others")
require("custom-filetype")

if vim.g.neovide then
  require("neovide-conf")
end
