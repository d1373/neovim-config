return {
	{
		"stevearc/oil.nvim",
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		lazy = false,
		config = function()
			require("oil").setup({
				view_options = {
					show_hidden = true,
					is_hidden_file = function(name, bufnr)
						local m = name:match("^%.")
						return m ~= nil
					end,
					is_always_hidden = function(name, bufnr)
						return false
					end,
					natural_order = "fast",
					case_insensitive = false,
					highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
						return nil
					end,
				},
				float = {
					-- Padding around the floating window
					padding = 2,
					-- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
					max_width = 0.6,
					max_height = 0.6,
					border = "rounded",
					win_options = {
						winblend = 0,
					},
					-- optionally override the oil buffers window title with custom function: fun(winid: integer): string
					get_win_title = nil,
					-- preview_split: Split direction: "auto", "left", "right", "above", "below".
					preview_split = "auto",
					-- This is the config that will be passed to nvim_open_win.
					-- Change values here to customize the layout
					override = function(conf)
						return conf
					end,
				},
			})
			vim.keymap.set("n", "<leader>o", function()
				if vim.bo.filetype == "oil" then
					require("oil.actions").close.callback()
				else
					vim.cmd("Oil --float")
				end
			end, { noremap = true, silent = true, desc = "Toggle Oil.nvim" })
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		-- autoclose tags
		"windwp/nvim-ts-autotag",
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()
			local vk = vim.keymap
			vk.set("n", "<leader>a", function()
				harpoon:list():add()
			end)
			vk.set("n", "<leader>e", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vk.set("n", "<leader>h", function()
				harpoon:list():select(1)
			end)
			vk.set("n", "<leader>j", function()
				harpoon:list():select(2)
			end)
			vk.set("n", "<leader>k", function()
				harpoon:list():select(3)
			end)
			vk.set("n", "<leader>l", function()
				harpoon:list():select(4)
			end)
		end,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-mini/mini.icons" },
		opts = {},
	},
}
