return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "notes",
					path = "~/Notes",
				},
			},
			notes_subdir = nil,
			new_notes_location = "current_dir",

			templates = {
				folder = "Template", -- relative to your vault
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
			},
			ui = {
				enable = false, -- Let render-markdown handle the UI
			},

			mappings = {
				["gf"] = {
					action = function()
						return require("obsidian").util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},
				["gk"] = {
					action = function()
						return require("obsidian").util.follow_url_func()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},
			},
		},
	},
	{
		"chomosuke/typst-preview.nvim",
		lazy = true, -- or ft = 'typst'
		version = "1.*",
	},
}
