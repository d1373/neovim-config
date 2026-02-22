return {
	{
		"vague2k/vague.nvim",
		config = function()
			require("vague").setup({
				transparent = true, -- don't set background
			})
			vim.cmd.colorscheme("vague")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs_staged_enable = true,
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
