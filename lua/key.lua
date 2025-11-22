local opts = { noremap = true, silent = true }
local vk = vim.keymap

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
vk.set("n", "<leader>gp", ":Gitsigns preview_hunk<cr>", { desc = "Gitsigns hunk preview" })
vk.set("", "<M-p>", ":FzfLua files<cr>", { desc = "Pick Files" })
vk.set("", "<C-?>", ":FzfLua helptags<cr>", { desc = "help" })
vk.set("", "<M-P>", ":FzfLua git-files<cr>", { desc = "Pick Files" })
vk.set("", "<M-s>", ":FzfLua live_grep_native<cr>", { desc = "Live Grep" })
vk.set("n", "<leader>tp", "<cmd>TypstPreviewFollowCursorToggle<cr>", { desc = "Typst Preview Follow Cursor Toggle" })
vk.set("n", "<leader>sr", ":%s/<C-r><C-w>//gc<Left><Left><left>", { desc = "Search and replace word under cursor" })
-- Quick substitute shortcuts
vk.set("n", "<leader>S", ":%s//g<Left><Left>", { desc = "Global substitute" })
vk.set("v", "<leader>S", ":s//g<Left><Left>", { desc = "Substitute in selection" })
vk.set("n", "<M-o>", function()
	require("fzf-lua").files({
		cwd = "~/Notes/",
		hidden = false,
		fd_opts = "--type f --strip-cwd-prefix --hidden --exclude '.*'",
	})
end, { desc = "Find files in specific dir" })
local M = {}

M.create_note_from_template = function()
	vim.ui.input({ prompt = "Note name: " }, function(input)
		if not input or input == "" then
			vim.notify("Cancelled: no name provided", vim.log.levels.INFO)
			return
		end

		-- 1. Remove any unwanted characters (keep only letters, digits, underscore, dash, space)
		local filename = input:gsub("[^%w _%-]", "")

		-- 2. Trim leading/trailing whitespace and dots
		filename = filename:match("^%s*(.-)%s*$") -- trim whitespace
		filename = filename:gsub("%.+$", "") -- remove trailing dots

		-- 3. Replace spaces with underscores and collapse repeated underscores
		filename = filename:gsub("%s+", "_"):gsub("_+", "_")

		-- 4. If user provided a dot-extension exactly ".md", keep it; otherwise append .md
		if not filename:match("%.md$") then
			filename = filename .. ".md"
		end

		-- 5. Use fnameescape (not shellescape) to pass a safe filename to a Vim/Ex command
		local safe = vim.fn.fnameescape(filename)

		-- Call the Obsidian command with the escaped filename
		local cmd = "ObsidianNewFromTemplate " .. safe
		vim.cmd(cmd)
	end)
end

vim.keymap.set("n", "<M-n>", M.create_note_from_template, { desc = "Obsidian: new from default template" })
