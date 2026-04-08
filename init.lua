local vo = vim.opt
local vg = vim.g
local vk = vim.keymap
local opts = { noremap = true, silent = true }


-- SET
vo.termguicolors = true
vo.cursorline = true
vo.path:append("**") -- Recursive path search
vo.wildmenu = true
vo.incsearch = true
vo.hidden = true
vo.ignorecase = true
vo.smartcase = true
vo.backup = false
vo.swapfile = false
vo.tabstop = 2
vo.shiftwidth = 2
vo.expandtab = true
vo.smarttab = true
vo.mouse = "a"
vo.number = true
vo.relativenumber = true
vg.have_nerd_font = false
vo.showmode = false
vo.undofile = true
vo.laststatus = 3
vo.winborder = "rounded"
vo.clipboard = "unnamedplus"
vg.mapleader = " "
vg.maplocalleader = " "

-- PACK
vim.pack.add{
	{src="https://github.com/stevearc/oil.nvim"},
	{src="https://github.com/nvim-mini/mini.nvim"},
  {src="https://github.com/vague-theme/vague.nvim"},
  {src="https://github.com/lewis6991/gitsigns.nvim"},
  {src="https://github.com/christoomey/vim-tmux-navigator"},
  {src="https://github.com/supermaven-inc/supermaven-nvim"},

}
-- MINI
require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.comment").setup({
mappings = {
	comment = "<M-/>",
	comment_line = "<M-/>",
	comment_visual = "<M-/>",
},})
require("mini.trailspace").setup()
require("mini.icons").setup()
require("mini.statusline").setup()
require("mini.pick").setup({
    mappings = {
    scroll_down  = '<C-j>',
    scroll_up    = '<C-k>',
  },
})
MiniPick.registry.files = function()
  return MiniPick.builtin.cli({
    command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' }
  }, {
    source = {
      show = function(buf_id, items, query)
        MiniPick.default_show(buf_id, items, query, { show_icons = true })
      end,
    },
  })
end
-- OIL
require("oil").setup({
view_options = {
	show_hidden = true,
},})
vk.set("n", "<leader>o", function()
	if vim.bo.filetype == "oil" then
		require("oil.actions").close.callback()
	else
		vim.cmd("Oil")
	end
end, { noremap = true, silent = true, desc = "Toggle Oil.nvim" })
-- COlOR
require("vague").setup({transparent = true})
vim.cmd.colorscheme("vague")
require("gitsigns").setup({
  signs_staged_enable = true,
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
})
-- AUTOCOMPLETE
require("supermaven-nvim").setup({
	keymaps = {
		accept_suggestion = "<M-;>",
		clear_suggestion = "<C-]>",
		accept_word = "<C-;>",
	},

	color = {
		suggestion_color = "#888888",
		cterm = 244,
	},
	log_level = "info",
	disable_inline_completion = false,
	disable_keymaps = false,
	condition = function()
		return false
	end,
})
--KEYMAP
vk.set("", "q", "<Nop>")
vk.set("", "B", "0")
vk.set("", "E", "$")
vk.set("n", "Q", "<nop>")
vk.set("n", "=", "<C-a>")
vk.set("n", "-", "<C-x>")
vk.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vk.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
vk.set("", "j", "gj")
vk.set("", "k", "gk")
vk.set("", "<C-d>", "<C-d>zz")
vk.set("", "<C-u>", "<C-u>zz")
vk.set("", "G", "Gzz")
vk.set("", "<C-b>", ":vs<CR>", { silent = true })
vk.set("", "<M-Left>", ":vertical resize +3<CR>", { silent = true })
vk.set("", "<M-Right>", ":vertical resize -3<CR>", { silent = true })
vk.set("", "<M-Up>", ":resize +3<CR>", { silent = true })
vk.set("", "<M-Down>", ":resize -3<CR>", { silent = true })
vk.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vk.set("n", "n", "nzzzv", opts)
vk.set("n", "<leader>sr", ":%s/<C-r><C-w>//gc<Left><Left><left>", { desc = "Search and replace word under cursor" })
vk.set("n", "<leader>S", ":%s//g<Left><Left>", { desc = "Global substitute" })
vk.set("v", "<leader>S", ":s//g<Left><Left>", { desc = "Substitute in selection" })
vk.set("", "<leader>F", ":Pick files<cr>", { desc = "Pick Files" })
vk.set("", "<leader>H", ":Pick help<cr>", { desc = "help" })
vk.set("", "<leader>ss", ":w | Pick grep_live<cr>", { desc = "Live Grep" })
vk.set("", "<leader>b", ":Pick buffers<cr>", { desc = "Pick Buffers" })
