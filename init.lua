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
vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/creativenull/efmls-configs-nvim" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
})
-- MINI
require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.comment").setup({
	mappings = {
		comment = "<M-/>",
		comment_line = "<M-/>",
		comment_visual = "<M-/>",
	},
})
require("mini.trailspace").setup()
require("mini.icons").setup()
require("mini.pick").setup({
	mappings = {
		scroll_down = "<C-j>",
		scroll_up = "<C-k>",
	},
})
MiniPick.registry.files = function()
	return MiniPick.builtin.cli({
		command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
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
	},
})
vk.set("n", "<leader>o", function()
	if vim.bo.filetype == "oil" then
		require("oil.actions").close.callback()
	else
		vim.cmd("Oil")
	end
end, { noremap = true, silent = true, desc = "Toggle Oil.nvim" })
-- COlOR
require("vague").setup({ transparent = true })
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

-- LSP
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"pyright",
		"clangd",
		"ts_ls",
		"bashls",
		"gopls",
		"rust_analyzer",
		"sqls",
		"tailwindcss",
		"markdown-oxide",
		"luacheck",
		"flake8",
		"eslint_d",
		"shellcheck",
		"cpplint",
		"revive",
		"sqlfluff",
		"stylua",
		"black",
		"prettierd",
		"fixjson",
		"shfmt",
		"clang-format",
		"gofumpt",
	},
})

-- load vscode snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- diagnostics
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	virtual_text = { prefix = "●" },
	severity_sort = true,
	float = { border = "rounded" },
})

-- LSP configs
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
			telemetry = { enable = false },
		},
	},
})

do
	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")
	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")
	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local eslint_d = require("efmls-configs.linters.eslint_d")
	local fixjson = require("efmls-configs.formatters.fixjson")
	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")
	local cpplint = require("efmls-configs.linters.cpplint")
	local clangfmt = require("efmls-configs.formatters.clang_format")
	local go_revive = require("efmls-configs.linters.go_revive")
	local gofumpt = require("efmls-configs.formatters.gofumpt")
	local sqlfluff = require("efmls-configs.linters.sqlfluff")
	local sqlfluffm = require("efmls-configs.formatters.sqlfluff")

	vim.lsp.config("efm", {
		filetypes = {
			"c",
			"cpp",
			"css",
			"go",
			"html",
			"javascript",
			"javascriptreact",
			"json",
			"jsonc",
			"lua",
			"markdown",
			"python",
			"sh",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
			"sql",
		},
		init_options = { documentFormatting = true },
		settings = {
			languages = {
				c = { clangfmt, cpplint },
				cpp = { clangfmt, cpplint },
				css = { prettier_d },
				html = { prettier_d },
				markdown = { prettier_d },
				go = { gofumpt, go_revive },
				javascript = { eslint_d, prettier_d },
				javascriptreact = { eslint_d, prettier_d },
				typescript = { eslint_d, prettier_d },
				typescriptreact = { eslint_d, prettier_d },
				vue = { eslint_d, prettier_d },
				svelte = { eslint_d, prettier_d },
				json = { eslint_d, fixjson },
				jsonc = { eslint_d, fixjson },
				lua = { luacheck, stylua },
				python = { flake8, black },
				sh = { shellcheck, shfmt },
				sql = { sqlfluff, sqlfluffm },
			},
		},
	})
end

vim.lsp.enable({
	"lua_ls",
	"pyright",
	"bashls",
	"ts_ls",
	"gopls",
	"clangd",
	"efm",
	"rust_analyzer",
	"sqls",
	"tailwindcss",
	"markdown-oxide",
})

-- format on save via efm
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end
		for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			if c.name == "efm" then
				pcall(vim.lsp.buf.format, {
					bufnr = args.buf,
					timeout_ms = 2000,
					filter = function(cl)
						return cl.name == "efm"
					end,
				})
				return
			end
		end
	end,
})

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local o = { buffer = ev.buf, silent = true }
		vim.keymap.set("n", "K", vim.lsp.buf.hover, o)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, o)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, o)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, o)
		vim.keymap.set("n", "<leader>D", function()
			vim.diagnostic.open_float({ scope = "line" })
		end, o)
		vim.keymap.set("n", "<leader>nd", function()
			vim.diagnostic.jump({ count = 1 })
		end, o)
		vim.keymap.set("n", "<leader>pd", function()
			vim.diagnostic.jump({ count = -1 })
		end, o)
	end,
})

-- blink.cmp
require("blink.cmp").setup({
	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = {
			download = true,
			force_version = "1.*",
		},
	},
	keymap = {
		preset = "none",
		["<CR>"] = { "accept", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-Space>"] = { "show", "hide" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
	completion = { menu = { auto_show = true } },
	snippets = {
		preset = "luasnip",
		expand = function(snippet)
			require("luasnip").lsp_expand(snippet)
		end,
	},
	sources = { default = { "lsp", "path", "snippets", "buffer" } },
})

-- ============================================================================
-- STATUSLINE
-- ============================================================================

-- Git branch function with caching and Nerd Font icon
local cached_branch = ""
local last_check = 0
local function git_branch()
	local now = vim.loop.now()
	if now - last_check > 5000 then -- Check every 5 seconds
		cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
		last_check = now
	end
	if cached_branch ~= "" then
		return " \u{e725} " .. cached_branch .. " " -- nf-dev-git_branch
	end
	return ""
end

-- File type with Nerd Font icon
local function file_type()
	local ft = vim.bo.filetype
	local icons = {
		lua = "\u{e620} ", -- nf-dev-lua
		python = "\u{e73c} ", -- nf-dev-python
		javascript = "\u{e74e} ", -- nf-dev-javascript
		typescript = "\u{e628} ", -- nf-dev-typescript
		javascriptreact = "\u{e7ba} ",
		typescriptreact = "\u{e7ba} ",
		html = "\u{e736} ", -- nf-dev-html5
		css = "\u{e749} ", -- nf-dev-css3
		scss = "\u{e749} ",
		json = "\u{e60b} ", -- nf-dev-json
		markdown = "\u{e73e} ", -- nf-dev-markdown
		vim = "\u{e62b} ", -- nf-dev-vim
		sh = "\u{f489} ", -- nf-oct-terminal
		bash = "\u{f489} ",
		zsh = "\u{f489} ",
		rust = "\u{e7a8} ", -- nf-dev-rust
		go = "\u{e724} ", -- nf-dev-go
		c = "\u{e61e} ", -- nf-dev-c
		cpp = "\u{e61d} ", -- nf-dev-cplusplus
		java = "\u{e738} ", -- nf-dev-java
		php = "\u{e73d} ", -- nf-dev-php
		ruby = "\u{e739} ", -- nf-dev-ruby
		swift = "\u{e755} ", -- nf-dev-swift
		kotlin = "\u{e634} ",
		dart = "\u{e798} ",
		elixir = "\u{e62d} ",
		haskell = "\u{e777} ",
		sql = "\u{e706} ",
		yaml = "\u{f481} ",
		toml = "\u{e615} ",
		xml = "\u{f05c} ",
		dockerfile = "\u{f308} ", -- nf-linux-docker
		gitcommit = "\u{f418} ", -- nf-oct-git_commit
		gitconfig = "\u{f1d3} ", -- nf-fa-git
		vue = "\u{fd42} ", -- nf-md-vuejs
		svelte = "\u{e697} ",
		astro = "\u{e628} ",
	}

	if ft == "" then
		return " \u{f15b} " -- nf-fa-file_o
	end

	return ((icons[ft] or " \u{f15b} ") .. ft)
end

-- File size with Nerd Font icon
local function file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%"))
	if size < 0 then
		return ""
	end
	local size_str
	if size < 1024 then
		size_str = size .. "B"
	elseif size < 1024 * 1024 then
		size_str = string.format("%.1fK", size / 1024)
	else
		size_str = string.format("%.1fM", size / 1024 / 1024)
	end
	return " \u{f016} " .. size_str .. " " -- nf-fa-file_o
end

-- Mode indicators with Nerd Font icons
local function mode_icon()
	local mode = vim.fn.mode()
	local modes = {
		n = " \u{f121}  NORMAL",
		i = " \u{f11c}  INSERT",
		v = " \u{f0168} VISUAL",
		V = " \u{f0168} V-LINE",
		["\22"] = " \u{f0168} V-BLOCK",
		c = " \u{f120} COMMAND",
		s = " \u{f0c5} SELECT",
		S = " \u{f0c5} S-LINE",
		["\19"] = " \u{f0c5} S-BLOCK",
		R = " \u{f044} REPLACE",
		r = " \u{f044} REPLACE",
		["!"] = " \u{f489} SHELL",
		t = " \u{f120} TERMINAL",
	}
	return modes[mode] or (" \u{f059} " .. mode)
end

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
		callback = function()
			vim.opt_local.statusline = table.concat({
				"  ",
				"%#StatusLineBold#",
				"%{v:lua.mode_icon()}",
				"%#StatusLine#",
				" \u{e0b1} %f %h%m%r", -- nf-pl-left_hard_divider
				"%{v:lua.git_branch()}",
				"\u{e0b1} ", -- nf-pl-left_hard_divider
				"%{v:lua.file_type()}",
				"\u{e0b1} ", -- nf-pl-left_hard_divider
				"%{v:lua.file_size()}",
				"%=", -- Right-align everything after this
				" \u{f017} %l:%c  %P ", -- nf-fa-clock_o for line/col
			})
		end,
	})
	vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			vim.opt_local.statusline = "  %f %h%m%r \u{e0b1} %{v:lua.file_type()} %=  %l:%c   %P "
		end,
	})
end

setup_dynamic_statusline()
