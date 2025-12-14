return {
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<M-;>",
					clear_suggestion = "<C-]>",
					accept_word = "<C-;>",
				},
				--ignore_filetypes = { cpp = false }, -- or { "cpp", }
				color = {
					suggestion_color = "#888888",
					cterm = 244,
				},
				log_level = "info", -- set to "off" to disable logging completely
				disable_inline_completion = false, -- disables inline completion for use with cmp
				disable_keymaps = false, -- disables built in keymaps for more manual control
				condition = function()
					return false
				end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
			})
		end,
	},
	{
		"greggh/claude-code.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for git operations
		},
		config = function()
			require("claude-code").setup({
				window = {
					split_ratio = 0.35, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
					position = "rightbelow vsplit", -- Position of the window: "botright", "topleft", "vertical", "float", etc.
					enter_insert = true, -- Whether to enter insert mode when opening Claude Code
					hide_numbers = true, -- Hide line numbers in the terminal window
					hide_signcolumn = true, -- Hide the sign column in the terminal window
				},
			})

			vim.keymap.set("n", "<leader>cc", ":ClaudeCode<CR>", { desc = "Toggle Claude Code window" })
		end,
	},
	{
		"kkrampis/codex.nvim",
		lazy = true,
		cmd = { "Codex", "CodexToggle" }, -- Optional: Load only on command execution
		keys = {
			{
				"<leader>cg", -- Change this to your preferred keybinding
				function()
					require("codex").toggle()
				end,
				desc = "Toggle Codex popup or side-panel",
				mode = { "n", "t" },
			},
		},
		opts = {
			keymaps = {
				toggle = nil, -- Keybind to toggle Codex window (Disabled by default, watch out for conflicts)
				quit = "<C-q>", -- Keybind to close the Codex window (default: Ctrl + q)
			}, -- Disable internal default keymap (<leader>cc -> :CodexToggle)
			width = 0.4, -- Width of the floating window (0.0 to 1.0)
			model = nil, -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
			autoinstall = true, -- Automatically install the Codex CLI if not found
			panel = true, -- Open Codex in a side-panel (vertical split) instead of floating window
		},
		config = function(_, opts)
			require("codex").setup(opts)
		end,
	},
}
