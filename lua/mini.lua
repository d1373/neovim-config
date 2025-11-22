return {
	"nvim-mini/mini.nvim",
	version = false,
	config = function()
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
		require("mini.statusline").setup()
	end,
}
